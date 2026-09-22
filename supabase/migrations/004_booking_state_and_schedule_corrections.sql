-- 004_booking_state_and_schedule_corrections.sql
-- Fixes for Double Booking Over-restriction and Booking State Machine

-- =====================================================================================
-- 1. FIX DOUBLE BOOKING OVER-RESTRICTION
-- =====================================================================================
-- Drop the overly restrictive exclusion constraints from 003
ALTER TABLE public.worker_availability DROP CONSTRAINT IF EXISTS exclude_overlapping_availability;
ALTER TABLE public.job_sequence_items DROP CONSTRAINT IF EXISTS exclude_overlapping_sequence_items;

-- Re-create them with a WHERE predicate so CANCELLED/AVAILABLE states don't block schedules
ALTER TABLE public.worker_availability
    ADD CONSTRAINT exclude_overlapping_availability 
    EXCLUDE USING gist (
        worker_id WITH =,
        slot_date WITH =,
        timerange(start_time, end_time) WITH &&
    ) WHERE (status IN ('BOOKED', 'BLOCKED'));

ALTER TABLE public.job_sequence_items
    ADD CONSTRAINT exclude_overlapping_sequence_items
    EXCLUDE USING gist (
        assigned_worker_id WITH =,
        sequence_date WITH =,
        timerange(start_time, end_time) WITH &&
    ) WHERE (status IN ('BOOKED', 'IN_PROGRESS', 'UNDER_REVIEW', 'COMPLETED'));

-- Drop the absolute UNIQUE constraint on step_id in bookings, which prevented re-booking a cancelled step.
ALTER TABLE public.bookings DROP CONSTRAINT IF EXISTS bookings_step_id_key;

-- Replace with a Partial Unique Index that only enforces uniqueness for ACTIVE bookings.
CREATE UNIQUE INDEX IF NOT EXISTS unique_active_booking_per_step 
ON public.bookings (step_id) 
WHERE status IN ('REQUESTED', 'ACCEPTED', 'COMPLETED');


-- =====================================================================================
-- 2. AUTOMATIC SCHEDULE FREEING ON CANCELLATION
-- =====================================================================================
-- When a booking is CANCELLED or DECLINED, we must update the underlying slots and steps
-- so they no longer trigger the exclusion constraints above.
CREATE OR REPLACE FUNCTION public.sync_schedule_on_booking_status_change() RETURNS TRIGGER AS \$\$
BEGIN
    -- Transition to CANCELLED or DECLINED (Free the schedule)
    IF NEW.status IN ('CANCELLED', 'DECLINED') AND OLD.status NOT IN ('CANCELLED', 'DECLINED') THEN
        UPDATE public.job_sequence_items
        SET status = 'READY_TO_BOOK',
            assigned_worker_id = NULL
        WHERE id = NEW.step_id;
        
        IF NEW.slot_id IS NOT NULL THEN
            UPDATE public.worker_availability
            SET status = 'AVAILABLE'
            WHERE id = NEW.slot_id;
        END IF;
    END IF;
    
    -- Transition to ACCEPTED (Lock the schedule)
    IF NEW.status = 'ACCEPTED' AND OLD.status != 'ACCEPTED' THEN
        UPDATE public.job_sequence_items
        SET status = 'BOOKED'
        WHERE id = NEW.step_id;
        
        IF NEW.slot_id IS NOT NULL THEN
            UPDATE public.worker_availability
            SET status = 'BOOKED'
            WHERE id = NEW.slot_id;
        END IF;
    END IF;
    
    RETURN NEW;
END;
\$\$ LANGUAGE plpgsql SECURITY DEFINER SET search_path = public;

DROP TRIGGER IF EXISTS trigger_sync_schedule_on_booking_change ON public.bookings;
CREATE TRIGGER trigger_sync_schedule_on_booking_change
AFTER UPDATE ON public.bookings
FOR EACH ROW EXECUTE FUNCTION public.sync_schedule_on_booking_status_change();


-- =====================================================================================
-- 3. BOOKING STATE MACHINE & ROLE-BASED TRANSITIONS
-- =====================================================================================
CREATE OR REPLACE FUNCTION public.validate_booking_status_transition() RETURNS TRIGGER AS \$\$
DECLARE
    is_admin BOOLEAN := public.is_admin();
    is_customer BOOLEAN := (auth.uid() = NEW.customer_id);
    is_worker BOOLEAN := (auth.uid() = NEW.worker_id);
BEGIN
    -- If status hasn't changed, validation is unnecessary
    IF NEW.status = OLD.status THEN
        RETURN NEW;
    END IF;

    -- Admins can override any transition
    IF is_admin THEN
        RETURN NEW;
    END IF;

    -- Validate Transitions based on existing enum ('REQUESTED', 'ACCEPTED', 'DECLINED', 'COMPLETED', 'CANCELLED')
    IF OLD.status = 'REQUESTED' THEN
        IF NEW.status NOT IN ('ACCEPTED', 'DECLINED', 'CANCELLED') THEN
            RAISE EXCEPTION 'Invalid transition from REQUESTED to %', NEW.status;
        END IF;
        -- Role restrictions
        IF is_customer AND NEW.status IN ('ACCEPTED', 'DECLINED') THEN
            RAISE EXCEPTION 'Unauthorized: Customers cannot accept or decline bookings.';
        END IF;

    ELSIF OLD.status = 'ACCEPTED' THEN
        IF NEW.status NOT IN ('COMPLETED', 'CANCELLED') THEN
            RAISE EXCEPTION 'Invalid transition from ACCEPTED to %', NEW.status;
        END IF;
        -- Role restrictions
        IF is_customer AND NEW.status = 'COMPLETED' THEN
            RAISE EXCEPTION 'Unauthorized: Customers cannot mark bookings as COMPLETED.';
        END IF;

    ELSIF OLD.status IN ('DECLINED', 'COMPLETED', 'CANCELLED') THEN
        RAISE EXCEPTION 'Invalid transition: % is a terminal state and cannot be changed.', OLD.status;
        
    ELSE
        RAISE EXCEPTION 'Unknown state transition from % to %', OLD.status, NEW.status;
    END IF;

    RETURN NEW;
END;
\$\$ LANGUAGE plpgsql SECURITY DEFINER SET search_path = public;

DROP TRIGGER IF EXISTS trigger_validate_booking_status ON public.bookings;
CREATE TRIGGER trigger_validate_booking_status
BEFORE UPDATE ON public.bookings
FOR EACH ROW EXECUTE FUNCTION public.validate_booking_status_transition();

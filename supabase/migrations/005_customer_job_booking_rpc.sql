-- 005_customer_job_booking_rpc.sql
-- Phase 2C Slice 3: atomic customer job + sequence + booking creation
-- Apply this migration once to the hosted Supabase project.

ALTER TABLE public.jobs
  ADD COLUMN IF NOT EXISTS site_address TEXT,
  ADD COLUMN IF NOT EXISTS special_instructions TEXT;

-- Ensure every new authenticated customer also has the profile row required by jobs.customer_id.
CREATE OR REPLACE FUNCTION public.handle_new_user() RETURNS TRIGGER AS $$
BEGIN
  INSERT INTO public.profiles (id, email, role)
  VALUES (NEW.id, NEW.email, 'CUSTOMER')
  ON CONFLICT (id) DO NOTHING;

  INSERT INTO public.customer_profiles (user_id, full_name)
  VALUES (
    NEW.id,
    COALESCE(
      NULLIF(NEW.raw_user_meta_data->>'full_name', ''),
      NULLIF(split_part(COALESCE(NEW.email, ''), '@', 1), ''),
      'Customer'
    )
  )
  ON CONFLICT (user_id) DO NOTHING;

  RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER SET search_path = public;

DROP TRIGGER IF EXISTS on_auth_user_created ON auth.users;
CREATE TRIGGER on_auth_user_created
AFTER INSERT ON auth.users
FOR EACH ROW EXECUTE FUNCTION public.handle_new_user();

-- Backfill the development/test customer profile if the user already existed before this fix.
INSERT INTO public.customer_profiles (user_id, full_name)
SELECT p.id,
       COALESCE(NULLIF(split_part(COALESCE(p.email, ''), '@', 1), ''), 'Customer')
FROM public.profiles p
WHERE p.role = 'CUSTOMER'
  AND NOT EXISTS (
    SELECT 1 FROM public.customer_profiles cp WHERE cp.user_id = p.id
  );

CREATE OR REPLACE FUNCTION public.create_customer_job_booking(
  p_worker_id UUID,
  p_slot_id UUID,
  p_title TEXT,
  p_description TEXT,
  p_site_address TEXT,
  p_special_instructions TEXT DEFAULT NULL
)
RETURNS JSONB
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $$
DECLARE
  v_customer_id UUID := auth.uid();
  v_slot public.worker_availability%ROWTYPE;
  v_worker public.worker_profiles%ROWTYPE;
  v_job_id UUID;
  v_step_id UUID;
  v_booking_id UUID;
  v_order INT;
  v_hours NUMERIC(10,2);
  v_labor NUMERIC(10,2);
  v_fee NUMERIC(10,2) := 25.00;
  v_total NUMERIC(10,2);
BEGIN
  IF v_customer_id IS NULL THEN
    RAISE EXCEPTION 'Authentication required';
  END IF;

  IF NOT EXISTS (
    SELECT 1 FROM public.profiles
    WHERE id = v_customer_id AND role = 'CUSTOMER'
  ) THEN
    RAISE EXCEPTION 'Only customers can create bookings';
  END IF;

  IF p_title IS NULL OR btrim(p_title) = '' THEN
    RAISE EXCEPTION 'Job title is required';
  END IF;

  IF p_description IS NULL OR btrim(p_description) = '' THEN
    RAISE EXCEPTION 'Job description is required';
  END IF;

  IF p_site_address IS NULL OR btrim(p_site_address) = '' THEN
    RAISE EXCEPTION 'Job site address is required';
  END IF;

  SELECT * INTO v_worker
  FROM public.worker_profiles
  WHERE user_id = p_worker_id
    AND is_accepting_jobs = TRUE
  FOR UPDATE;

  IF NOT FOUND THEN
    RAISE EXCEPTION 'Selected worker is not available for new jobs';
  END IF;

  SELECT * INTO v_slot
  FROM public.worker_availability
  WHERE id = p_slot_id
    AND worker_id = p_worker_id
  FOR UPDATE;

  IF NOT FOUND THEN
    RAISE EXCEPTION 'Selected availability slot does not belong to this worker';
  END IF;

  IF v_slot.status <> 'AVAILABLE' THEN
    RAISE EXCEPTION 'Selected availability slot is no longer available';
  END IF;

  IF v_slot.slot_date < CURRENT_DATE THEN
    RAISE EXCEPTION 'Cannot book a slot in the past';
  END IF;

  IF EXISTS (
    SELECT 1 FROM public.bookings
    WHERE slot_id = p_slot_id
      AND status IN ('REQUESTED', 'ACCEPTED')
  ) THEN
    RAISE EXCEPTION 'Selected slot already has an active booking request';
  END IF;

  v_hours := ROUND(
    (EXTRACT(EPOCH FROM (v_slot.end_time - v_slot.start_time)) / 3600.0)::NUMERIC,
    2
  );

  IF v_hours <= 0 THEN
    RAISE EXCEPTION 'Invalid availability duration';
  END IF;

  v_labor := ROUND(v_worker.hourly_rate * v_hours, 2);
  v_total := v_labor + v_fee;

  SELECT COALESCE(MAX(sequence_order), 0) + 1
    INTO v_order
  FROM public.job_sequence_items
  WHERE assigned_worker_id = p_worker_id
    AND sequence_date = v_slot.slot_date;

  INSERT INTO public.jobs (
    customer_id, title, description, site_address,
    special_instructions, status, total_budget
  )
  VALUES (
    v_customer_id, btrim(p_title), btrim(p_description), btrim(p_site_address),
    NULLIF(btrim(COALESCE(p_special_instructions, '')), ''),
    'PUBLISHED', v_total
  )
  RETURNING id INTO v_job_id;

  INSERT INTO public.job_sequence_items (
    job_id, sequence_order, category_id, status,
    assigned_worker_id, sequence_date, start_time, end_time
  )
  VALUES (
    v_job_id, v_order, v_worker.category_id, 'READY_TO_BOOK',
    p_worker_id, v_slot.slot_date, v_slot.start_time, v_slot.end_time
  )
  RETURNING id INTO v_step_id;

  INSERT INTO public.bookings (
    step_id, customer_id, worker_id, slot_id,
    status, labor_cost, service_fee, total_amount
  )
  VALUES (
    v_step_id, v_customer_id, p_worker_id, p_slot_id,
    'REQUESTED', v_labor, v_fee, v_total
  )
  RETURNING id INTO v_booking_id;

  RETURN jsonb_build_object(
    'job_id', v_job_id,
    'step_id', v_step_id,
    'booking_id', v_booking_id,
    'slot_id', p_slot_id,
    'status', 'REQUESTED',
    'labor_cost', v_labor,
    'service_fee', v_fee,
    'total_amount', v_total,
    'sequence_order', v_order
  );
END;
$$;

REVOKE ALL ON FUNCTION public.create_customer_job_booking(UUID, UUID, TEXT, TEXT, TEXT, TEXT)
  FROM PUBLIC;

GRANT EXECUTE ON FUNCTION public.create_customer_job_booking(UUID, UUID, TEXT, TEXT, TEXT, TEXT)
  TO authenticated;

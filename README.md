# Job Sequence App

Flutter + Supabase job management and sequencing application with separate Customer, Worker, and Admin portals.

## Current Project Status

**Checkpoint: 2026-10-03 — Phase 2C live integration paused.**

### Completed

- Phase 1 — Material 3 UI prototype and Customer / Worker / Admin portal flows.
- Phase 2A — Supabase PostgreSQL foundation, RLS policies, booking state validation, schedule conflict protection, and security corrections.
- Phase 2B — Supabase authentication integrated into Flutter, including login, signup, logout, password recovery, and role-based routing.
- Phase 2C Slice 1 — Live worker discovery and service categories.
- Phase 2C Slice 2 — Live worker availability and customer date/time selection.
- Phase 2C Slice 3 — Atomic customer job + sequence item + booking creation through the `create_customer_job_booking` PostgreSQL RPC.
- Worker booking-request flow — Worker Requests now reads live `REQUESTED` bookings and supports Accept / Decline through Supabase.
- Development booking verification — A real customer booking was successfully created against a live worker availability slot.

### Current Checkpoint / Pending Verification

The next immediate verification is the Worker portal request lifecycle: log in as a worker, open Requests, accept the existing request, and verify booking / sequence / availability states in Supabase.

The following work is intentionally paused and is **not** marked complete:

- Full worker acceptance verification.
- Complete booking lifecycle and job execution integration.
- Customer tracking and notifications.
- Admin live operations.
- Reviews / ratings / completion workflow.
- Production hardening and full automated testing.
- Custom SMTP configuration for production-grade email delivery.

## Authentication Flow

The intended registration architecture is:

```text
User
  ↓
Flutter Create Account
  ↓
Supabase Auth.signUp()
  ↓
Custom SMTP
  ↓
Verification email
  ↓
User verifies email
  ↓
Login
  ↓
profiles → CUSTOMER
```

The Flutter signup code now handles both Supabase outcomes: an immediate authenticated session when email confirmation is disabled, or a created account requiring verification when confirmation is enabled. Custom SMTP still needs to be configured in the Supabase project before the production email-verification flow is complete.

New accounts are intentionally created as `CUSTOMER` by the database-side auth trigger. Worker/Admin privileges are not client-selectable.

## Architecture

```text
Flutter UI
   ↓
Feature screens
   ↓
Core services
   ↓
Supabase Auth / PostgreSQL
   ↓
RLS + database functions + constraints
```

Core backend tables include:

- `profiles`
- `customer_profiles`
- `service_categories`
- `worker_profiles`
- `worker_skills`
- `worker_availability`
- `jobs`
- `job_sequence_items`
- `bookings`
- `reviews`
- `notifications`
- `worker_verifications`

Database migrations currently tracked:

```text
supabase/migrations/
├── 001_initial_schema.sql
├── 002_rls_policies.sql
├── 003_security_and_v1_corrections.sql
├── 004_booking_state_and_schedule_corrections.sql
└── 005_customer_job_booking_rpc.sql
```

## Key Security Decisions

- Supabase Auth owns passwords; public application tables do not store plaintext passwords.
- New users default to `CUSTOMER` through the database auth trigger.
- Role changes are protected by database-side authorization rules.
- RLS is enabled for application data.
- Booking state transitions are validated in PostgreSQL.
- Worker availability and job-sequence overlap are protected by database constraints.
- Customer booking creation is performed atomically by a PostgreSQL RPC rather than by three independent client inserts.
- The Flutter client does not contain a Supabase service-role secret.

## Booking Flow Implemented So Far

```text
Customer
  ↓
Live worker discovery
  ↓
Live worker availability
  ↓
Select date/time slot
  ↓
Create job + sequence item + booking (atomic RPC)
  ↓
Booking status = REQUESTED
  ↓
Worker Requests
  ↓
Accept / Decline
  ↓
[Next verification checkpoint]
```

The current V1 sequence model is intentionally a **flat sequence** ordered by worker, date, start/end time, and sequence order. A dependency DAG is not part of the current V1 architecture.

## Tech Stack

- Flutter / Dart
- Material 3
- Supabase Flutter
- PostgreSQL
- Supabase Auth
- Row Level Security (RLS)
- PostgreSQL functions, triggers, indexes, and exclusion constraints

## Project Structure

```text
lib/
├── core/
│   ├── models/
│   ├── services/
│   ├── mock_data/
│   └── widgets/
└── features/
    ├── auth/
    ├── customer/
    ├── worker/
    ├── admin/
    └── role_selection/

supabase/
└── migrations/
```

## Run Locally

```bash
flutter pub get
flutter run -d chrome
```

Static analysis:

```bash
flutter analyze
```

Tests:

```bash
flutter test
```

> Note: Windows environment/tooling issues have previously prevented the full test suite from completing. The repository should not be treated as having a fully verified passing test suite until it is rerun successfully.

## Development Notes

- `supabase_combined_setup.sql` is retained as a historical/manual setup artifact and should **not** be blindly rerun against an already-configured hosted database. The numbered migrations are the authoritative progression.
- The current booking RPC uses a server-side fixed service fee for the V1 development flow. A configurable pricing model is future work.
- Some UI screens still contain prototype payment/escrow wording. Real payment processing / escrow is not implemented yet.

## Roadmap

```text
Phase 0  → Cleanup & baseline
Phase 1  → UI prototype                         Complete
Phase 2A → Supabase foundation                 Complete
Phase 2B → Authentication                       Core complete
Phase 2C → Live data integration                In progress / paused
Phase 3  → Complete booking lifecycle
Phase 4  → Worker sequencing & execution
Phase 5  → Customer tracking & notifications
Phase 6  → Admin operations
Phase 7  → Reviews, ratings & completion
Phase 8  → Security & production hardening
Phase 9  → Full testing & bug fixing
Phase 10 → Demo / deployment
```

## Repository

https://github.com/Dhodiapreet/job-sequence-app

---

**Current checkpoint:** implementation paused after the live customer booking flow and worker request implementation. Resume from Worker Request acceptance verification rather than restarting earlier phases.

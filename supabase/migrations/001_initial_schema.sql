-- 001_initial_schema.sql
-- Job Sequence App - Supabase Database Schema

-- ENUMS
CREATE TYPE user_role AS ENUM ('CUSTOMER', 'WORKER', 'ADMIN');
CREATE TYPE job_status AS ENUM ('DRAFT', 'PUBLISHED', 'IN_PROGRESS', 'COMPLETED', 'CANCELLED');
CREATE TYPE step_status AS ENUM ('PENDING_PREDECESSOR', 'READY_TO_BOOK', 'BOOKED', 'IN_PROGRESS', 'UNDER_REVIEW', 'COMPLETED');
CREATE TYPE booking_status AS ENUM ('REQUESTED', 'ACCEPTED', 'DECLINED', 'COMPLETED', 'CANCELLED');
CREATE TYPE slot_status AS ENUM ('AVAILABLE', 'BOOKED', 'BLOCKED');
CREATE TYPE verification_status AS ENUM ('PENDING', 'APPROVED', 'REJECTED');

-- 1. PROFILES (Base User Table linking to Supabase Auth)
CREATE TABLE profiles (
    id UUID PRIMARY KEY REFERENCES auth.users(id) ON DELETE CASCADE,
    email TEXT UNIQUE NOT NULL,
    role user_role NOT NULL,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- 2. CUSTOMER_PROFILES
CREATE TABLE customer_profiles (
    user_id UUID PRIMARY KEY REFERENCES profiles(id) ON DELETE CASCADE,
    full_name TEXT NOT NULL,
    avatar_url TEXT,
    total_jobs_booked INT DEFAULT 0,
    average_rating NUMERIC(3,2) DEFAULT 5.0
);

-- 3. SERVICE_CATEGORIES
CREATE TABLE service_categories (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    name TEXT UNIQUE NOT NULL,
    icon_identifier TEXT NOT NULL,
    color_code TEXT NOT NULL,
    is_active BOOLEAN DEFAULT TRUE
);

-- 4. WORKER_PROFILES
CREATE TABLE worker_profiles (
    user_id UUID PRIMARY KEY REFERENCES profiles(id) ON DELETE CASCADE,
    full_name TEXT NOT NULL,
    trade TEXT NOT NULL,
    category_id UUID REFERENCES service_categories(id),
    hourly_rate NUMERIC(10,2) NOT NULL,
    daily_rate NUMERIC(10,2) NOT NULL,
    rating NUMERIC(3,2) DEFAULT 0.0,
    reviews_count INT DEFAULT 0,
    jobs_completed INT DEFAULT 0,
    bio TEXT,
    safety_score INT DEFAULT 100,
    is_accepting_jobs BOOLEAN DEFAULT TRUE
);

-- 5. WORKER_SKILLS
CREATE TABLE worker_skills (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    worker_id UUID REFERENCES worker_profiles(user_id) ON DELETE CASCADE,
    category_id UUID REFERENCES service_categories(id),
    skill_name TEXT NOT NULL,
    proficiency TEXT
);

-- 6. WORKER_AVAILABILITY
CREATE TABLE worker_availability (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    worker_id UUID REFERENCES worker_profiles(user_id) ON DELETE CASCADE,
    slot_date DATE NOT NULL,
    start_time TIME NOT NULL,
    end_time TIME NOT NULL,
    status slot_status DEFAULT 'AVAILABLE'
);

-- 7. JOBS
CREATE TABLE jobs (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    customer_id UUID REFERENCES customer_profiles(user_id),
    title TEXT NOT NULL,
    description TEXT,
    status job_status DEFAULT 'DRAFT',
    total_budget NUMERIC(10,2) NOT NULL,
    progress_percent NUMERIC(5,2) DEFAULT 0.0,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- 8. JOB_SEQUENCE_ITEMS (Job Steps forming DAG)
CREATE TABLE job_sequence_items (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    job_id UUID REFERENCES jobs(id) ON DELETE CASCADE,
    sequence_order INT NOT NULL,
    category_id UUID REFERENCES service_categories(id),
    status step_status DEFAULT 'PENDING_PREDECESSOR',
    assigned_worker_id UUID REFERENCES worker_profiles(user_id),
    depends_on_step_ids UUID[] DEFAULT '{}'
);

-- 9. BOOKINGS
CREATE TABLE bookings (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    step_id UUID REFERENCES job_sequence_items(id) UNIQUE,
    customer_id UUID REFERENCES customer_profiles(user_id),
    worker_id UUID REFERENCES worker_profiles(user_id),
    slot_id UUID REFERENCES worker_availability(id),
    status booking_status DEFAULT 'REQUESTED',
    labor_cost NUMERIC(10,2) NOT NULL,
    service_fee NUMERIC(10,2) NOT NULL,
    total_amount NUMERIC(10,2) NOT NULL,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- 10. REVIEWS
CREATE TABLE reviews (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    booking_id UUID REFERENCES bookings(id) UNIQUE,
    author_id UUID REFERENCES profiles(id),
    target_id UUID REFERENCES profiles(id),
    rating NUMERIC(3,2) NOT NULL CHECK (rating >= 1.0 AND rating <= 5.0),
    comment TEXT,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- 11. NOTIFICATIONS
CREATE TABLE notifications (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID REFERENCES profiles(id) ON DELETE CASCADE,
    title TEXT NOT NULL,
    message TEXT NOT NULL,
    type TEXT,
    reference_id UUID,
    is_read BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- 12. WORKER_VERIFICATIONS
CREATE TABLE worker_verifications (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    worker_id UUID REFERENCES worker_profiles(user_id) ON DELETE CASCADE,
    document_type TEXT NOT NULL,
    document_url TEXT NOT NULL,
    status verification_status DEFAULT 'PENDING',
    reviewed_by_id UUID REFERENCES profiles(id),
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

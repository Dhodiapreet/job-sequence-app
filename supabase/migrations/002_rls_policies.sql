-- 002_rls_policies.sql
-- Row Level Security (RLS) Policies for Job Sequence App

-- Enable RLS on all tables
ALTER TABLE profiles ENABLE ROW LEVEL SECURITY;
ALTER TABLE customer_profiles ENABLE ROW LEVEL SECURITY;
ALTER TABLE service_categories ENABLE ROW LEVEL SECURITY;
ALTER TABLE worker_profiles ENABLE ROW LEVEL SECURITY;
ALTER TABLE worker_skills ENABLE ROW LEVEL SECURITY;
ALTER TABLE worker_availability ENABLE ROW LEVEL SECURITY;
ALTER TABLE jobs ENABLE ROW LEVEL SECURITY;
ALTER TABLE job_sequence_items ENABLE ROW LEVEL SECURITY;
ALTER TABLE bookings ENABLE ROW LEVEL SECURITY;
ALTER TABLE reviews ENABLE ROW LEVEL SECURITY;
ALTER TABLE notifications ENABLE ROW LEVEL SECURITY;
ALTER TABLE worker_verifications ENABLE ROW LEVEL SECURITY;

-- Utility function to check if user is admin
CREATE OR REPLACE FUNCTION is_admin() RETURNS BOOLEAN AS \$\$
BEGIN
  RETURN EXISTS (
    SELECT 1 FROM profiles WHERE id = auth.uid() AND role = 'ADMIN'
  );
END;
\$\$ LANGUAGE plpgsql SECURITY DEFINER;

-- 1. PROFILES
-- Users can read their own profile, Admins can read all.
CREATE POLICY "Users can read own profile" ON profiles FOR SELECT USING (auth.uid() = id OR is_admin());
CREATE POLICY "Users can update own profile" ON profiles FOR UPDATE USING (auth.uid() = id);

-- 2. CUSTOMER PROFILES
CREATE POLICY "Customers can read own profile" ON customer_profiles FOR SELECT USING (auth.uid() = user_id OR is_admin());
CREATE POLICY "Customers can update own profile" ON customer_profiles FOR UPDATE USING (auth.uid() = user_id);

-- 3. SERVICE CATEGORIES
-- Public read access so anyone can see categories
CREATE POLICY "Service categories are readable by everyone" ON service_categories FOR SELECT USING (TRUE);
CREATE POLICY "Only admins can modify categories" ON service_categories FOR ALL USING (is_admin());

-- 4. WORKER PROFILES
-- Anyone can see worker profiles (for searching/booking)
CREATE POLICY "Worker profiles are readable by everyone" ON worker_profiles FOR SELECT USING (TRUE);
CREATE POLICY "Workers can update own profile" ON worker_profiles FOR UPDATE USING (auth.uid() = user_id);

-- 5. WORKER SKILLS
CREATE POLICY "Worker skills are readable by everyone" ON worker_skills FOR SELECT USING (TRUE);
CREATE POLICY "Workers can manage own skills" ON worker_skills FOR ALL USING (auth.uid() = worker_id);

-- 6. WORKER AVAILABILITY
CREATE POLICY "Availability is readable by everyone" ON worker_availability FOR SELECT USING (TRUE);
CREATE POLICY "Workers can manage own availability" ON worker_availability FOR ALL USING (auth.uid() = worker_id);

-- 7. JOBS
CREATE POLICY "Customers can manage own jobs" ON jobs FOR ALL USING (auth.uid() = customer_id);
-- Workers can view a job if they are assigned to any step in it
CREATE POLICY "Workers can view jobs they are part of" ON jobs FOR SELECT USING (
    EXISTS (SELECT 1 FROM job_sequence_items WHERE job_id = jobs.id AND assigned_worker_id = auth.uid())
);
CREATE POLICY "Admins can view all jobs" ON jobs FOR SELECT USING (is_admin());

-- 8. JOB SEQUENCE ITEMS
CREATE POLICY "Customers can manage sequence items for their jobs" ON job_sequence_items FOR ALL USING (
    EXISTS (SELECT 1 FROM jobs WHERE jobs.id = job_sequence_items.job_id AND jobs.customer_id = auth.uid())
);
CREATE POLICY "Workers can view and update sequence items assigned to them" ON job_sequence_items FOR SELECT USING (assigned_worker_id = auth.uid());
CREATE POLICY "Workers can update sequence items assigned to them" ON job_sequence_items FOR UPDATE USING (assigned_worker_id = auth.uid());
CREATE POLICY "Admins can view all sequence items" ON job_sequence_items FOR SELECT USING (is_admin());

-- 9. BOOKINGS
CREATE POLICY "Customers can manage own bookings" ON bookings FOR ALL USING (auth.uid() = customer_id);
CREATE POLICY "Workers can read and update own bookings" ON bookings FOR SELECT USING (auth.uid() = worker_id);
CREATE POLICY "Workers can update own bookings" ON bookings FOR UPDATE USING (auth.uid() = worker_id);
CREATE POLICY "Admins can view all bookings" ON bookings FOR SELECT USING (is_admin());

-- 10. REVIEWS
CREATE POLICY "Reviews are readable by everyone" ON reviews FOR SELECT USING (TRUE);
CREATE POLICY "Users can create reviews" ON reviews FOR INSERT WITH CHECK (auth.uid() = author_id);
CREATE POLICY "Users can update own reviews" ON reviews FOR UPDATE USING (auth.uid() = author_id);

-- 11. NOTIFICATIONS
CREATE POLICY "Users can manage own notifications" ON notifications FOR ALL USING (auth.uid() = user_id);

-- 12. WORKER VERIFICATIONS
CREATE POLICY "Workers can read own verifications" ON worker_verifications FOR SELECT USING (auth.uid() = worker_id);
CREATE POLICY "Workers can insert own verifications" ON worker_verifications FOR INSERT WITH CHECK (auth.uid() = worker_id);
CREATE POLICY "Admins can manage all verifications" ON worker_verifications FOR ALL USING (is_admin());

-- 1. Create the table if it doesn't exist
CREATE TABLE IF NOT EXISTS bookings (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL,
    customer_name TEXT NOT NULL,
    customer_phone TEXT NOT NULL,
    booking_date DATE NOT NULL,
    booking_time TIME NOT NULL,
    package TEXT NOT NULL,
    status TEXT DEFAULT 'pending' CHECK (status IN ('pending', 'paid', 'completed', 'expired')),
    qr_code_id TEXT UNIQUE DEFAULT gen_random_uuid()::text,
    payment_id TEXT 
);

-- 2. Enable RLS (safe even if already on)
ALTER TABLE bookings ENABLE ROW LEVEL SECURITY;

-- 3. Cleanup old policies to avoid "already exists" errors
DROP POLICY IF EXISTS "Allow public insert" ON bookings;
DROP POLICY IF EXISTS "Allow public select" ON bookings;
DROP POLICY IF EXISTS "Allow admin all access" ON bookings;

-- 4. Re-add policies
CREATE POLICY "Allow public insert" ON bookings FOR INSERT WITH CHECK (true);
CREATE POLICY "Allow public select" ON bookings FOR SELECT USING (true);
CREATE POLICY "Allow admin all access" ON bookings FOR ALL USING (auth.role() = 'authenticated');

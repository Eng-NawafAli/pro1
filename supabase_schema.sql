-- Create the bookings table
CREATE TABLE bookings (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL,
    customer_name TEXT NOT NULL,
    customer_phone TEXT NOT NULL,
    booking_date DATE NOT NULL,
    booking_time TIME NOT NULL,
    package TEXT NOT NULL,
    status TEXT DEFAULT 'pending' CHECK (status IN ('pending', 'paid', 'completed', 'expired')),
    qr_code_id TEXT UNIQUE DEFAULT gen_random_uuid()::text,
    payment_id TEXT -- Store Moyasar payment ID here
);

-- Enable Row Level Security
ALTER TABLE bookings ENABLE ROW LEVEL SECURITY;

-- Allow anyone to insert a booking (Public)
CREATE POLICY "Allow public insert" ON bookings
FOR INSERT WITH CHECK (true);

-- Allow authenticated admins to select/update all bookings
CREATE POLICY "Allow admin all access" ON bookings
FOR ALL USING (auth.role() = 'authenticated');

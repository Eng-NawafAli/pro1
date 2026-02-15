-- Email Notification Setup Instructions
-- 
-- To receive email notifications when customers pay, you have 2 options:
--
-- OPTION 1: Use Supabase Database Webhooks (Recommended)
-- ========================================================
-- 1. Go to Supabase Dashboard → Database → Webhooks
-- 2. Create a new webhook with these settings:
--    - Name: "Payment Notification"
--    - Table: bookings
--    - Events: UPDATE
--    - Type: HTTP Request
--    - Method: POST
--    - URL: https://hooks.zapier.com/hooks/catch/YOUR_WEBHOOK_ID/
--      (Get this from Zapier - see Option 2 below)
--    - HTTP Headers: Content-Type: application/json
--    - Conditions: NEW.status = 'paid' AND OLD.status != 'paid'
--
-- OPTION 2: Use Zapier (Easiest - No Coding Required)
-- ====================================================
-- 1. Go to https://zapier.com and create a free account
-- 2. Create a new Zap:
--    Step 1: Trigger = "Webhooks by Zapier" → "Catch Hook"
--    Step 2: Action = "Email by Zapier" → "Send Outbound Email"
--            To: YOUR_EMAIL@example.com
--            Subject: "حجز جديد مدفوع - نادي الحريضة"
--            Body: Use these fields from webhook:
--                  - customer_name
--                  - customer_phone
--                  - booking_date
--                  - booking_time
--                  - package
--                  - qr_code_id
-- 3. Copy the Webhook URL from Step 1
-- 4. Use that URL in the Supabase Webhook (Option 1 above)
--
-- OPTION 3: Use Make.com (Alternative to Zapier)
-- ===============================================
-- Same as Zapier but use https://make.com instead
--
-- OPTION 4: Manual Email Check
-- =============================
-- Simply check your admin dashboard regularly!
-- The dashboard shows all paid bookings in real-time.

-- For testing, you can also add this SQL function to manually send test emails:
-- (Requires Supabase to have email configured)

CREATE OR REPLACE FUNCTION notify_admin_of_payment()
RETURNS TRIGGER AS $$
BEGIN
  -- This would require Supabase Edge Functions or external service
  -- For now, use Zapier/Make.com as described above
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Create trigger (optional - only if using Edge Functions)
-- DROP TRIGGER IF EXISTS on_payment_notify_admin ON bookings;
-- CREATE TRIGGER on_payment_notify_admin
--   AFTER UPDATE ON bookings
--   FOR EACH ROW
--   WHEN (NEW.status = 'paid' AND OLD.status != 'paid')
--   EXECUTE FUNCTION notify_admin_of_payment();

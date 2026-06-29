-- Phase 4 – Query Optimization

-- Creating indexes
CREATE INDEX idx_bookings_customer_id ON bookings(customer_id);
CREATE INDEX idx_bookings_booking_date ON bookings(booking_date);
CREATE INDEX idx_bookings_booking_status ON bookings(booking_status);
CREATE INDEX idx_bookings_event_category ON bookings(event_category);
CREATE INDEX idx_bookings_event_date ON bookings(event_date);

-- Filtering by Status and Category
-- Purpose: Analyzes how fast Postgres targets rows using combined indexed columns.
EXPLAIN ANALYZE
SELECT event_category, COUNT(*), SUM(tickets_booked * ticket_price)
FROM bookings
WHERE booking_status = 'Confirmed' AND event_category = 'Concert'
GROUP BY event_category;

-- Tracking Outdated or Forward-Looking Chronologies
-- Purpose: Checks performance of sorting and filtering on event dates.
EXPLAIN ANALYZE
SELECT event_name, venue, event_date
FROM bookings
WHERE event_date > '2025-12-31'
ORDER BY event_date ASC
LIMIT 100;
CREATE OR REPLACE VIEW vw_customer_booking_summary AS
SELECT 
    c.customer_name,
    c.membership_type,
    SUM(b.tickets_booked * b.ticket_price) AS total_revenue,
    SUM(b.tickets_booked) AS tickets_purchased,
    AVG(b.ticket_price) AS avg_ticket_price
FROM customers c
JOIN bookings b ON c.customer_id = b.customer_id
GROUP BY c.customer_id, c.customer_name, c.membership_type;

SELECT * FROM vw_customer_booking_summary;
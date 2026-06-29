-- Use Case 2 - Event Performance Dashboard

-- Task 1: Display the Top 10 revenue-generating events.
SELECT 
    event_name,
    SUM(tickets_booked * ticket_price) AS total_revenue
FROM bookings
GROUP BY event_name
ORDER BY total_revenue DESC
LIMIT 10;

-- Task 2: Calculate cumulative ticket sales for every event category.
SELECT 
    event_category,
    booking_id,
    tickets_booked,
    SUM(tickets_booked) OVER (PARTITION BY event_category ORDER BY booking_date, booking_id) AS cumulative_tickets_sold
FROM bookings;

-- Task 3:Calculate the rolling average ticket price using the last seven bookings.
SELECT 
    booking_id,
    ticket_price,
    AVG(ticket_price) OVER (ORDER BY booking_date, booking_id ROWS BETWEEN 6 PRECEDING AND CURRENT ROW) AS rolling_avg_price
FROM bookings;

-- Task 4: Find customers who booked tickets across more than three different event categories.
SELECT 
    c.customer_name,
    COUNT(DISTINCT b.event_category) AS distinct_categories
FROM customers c
JOIN bookings b ON c.customer_id = b.customer_id
GROUP BY c.customer_id, c.customer_name
HAVING COUNT(DISTINCT b.event_category) > 3;

-- Task 5: Find customers who have never cancelled a booking.
SELECT 
    customer_id,
    customer_name
FROM customers
WHERE customer_id NOT IN (
    SELECT DISTINCT customer_id 
    FROM bookings 
    WHERE booking_status = 'Cancelled'
);
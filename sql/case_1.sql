-- Use Case 1 - Customer Booking Analytics


-- Task 1 - Customer Revenue Report
-- Ordered by overall generated gross revenue in descending.
SELECT 
    c.customer_name,
    c.membership_type,
    COUNT(b.booking_id) AS total_bookings,
    SUM(b.tickets_booked) AS total_tickets_purchased,
    SUM(b.tickets_booked * b.ticket_price) AS total_revenue_generated
FROM customers c
INNER JOIN bookings b ON c.customer_id = b.customer_id
GROUP BY c.customer_id, c.customer_name, c.membership_type
ORDER BY total_revenue_generated DESC;


-- Task 2 - Customer Ranking
-- Using Window Functions, rank customers according to total spending.
SELECT 
    c.customer_id,
    c.customer_name,
    SUM(b.tickets_booked * b.ticket_price) AS total_spending,
    ROW_NUMBER() OVER (ORDER BY SUM(b.tickets_booked * b.ticket_price) DESC) AS spend_row_number,
    RANK() OVER (ORDER BY SUM(b.tickets_booked * b.ticket_price) DESC) AS spend_rank,
    DENSE_RANK() OVER (ORDER BY SUM(b.tickets_booked * b.ticket_price) DESC) AS spend_dense_rank
FROM customers c
INNER JOIN bookings b ON c.customer_id = b.customer_id
GROUP BY c.customer_id, c.customer_name;

-- Task 3 - Membership Analysis
-- Calculate:
-- Average customer spending for each membership type
-- Difference between customer spending and the membership average

WITH customer_spend_summary AS (
    SELECT 
        c.customer_id,
        c.customer_name,
        c.membership_type,
        SUM(b.tickets_booked * b.ticket_price) AS total_customer_spending
    FROM customers c
    INNER JOIN bookings b ON c.customer_id = b.customer_id
    GROUP BY c.customer_id, c.customer_name, c.membership_type
)
SELECT 
    customer_name,
    membership_type,
    total_customer_spending,
    AVG(total_customer_spending) OVER (PARTITION BY membership_type) AS avg_membership_spending,
    (total_customer_spending - AVG(total_customer_spending) OVER (PARTITION BY membership_type)) AS spending_difference
FROM customer_spend_summary;

-- Task 4 - Customer Segmentation
-- Divide customers into four equal groups
WITH ranked_spenders AS (
    SELECT 
        c.customer_id,
        c.customer_name,
        SUM(b.tickets_booked * b.ticket_price) AS total_spending,
        NTILE(4) OVER (ORDER BY SUM(b.tickets_booked * b.ticket_price) DESC) AS spending_quartile
    FROM customers c
    INNER JOIN bookings b ON c.customer_id = b.customer_id
    GROUP BY c.customer_id, c.customer_name
)
SELECT 
    customer_name,
    total_spending,
    CASE 
        WHEN spending_quartile = 1 THEN 'Premium'
        WHEN spending_quartile = 2 THEN 'High'
        WHEN spending_quartile = 3 THEN 'Medium'
        WHEN spending_quartile = 4 THEN 'Low'
    END AS customer_segment
FROM ranked_spenders;
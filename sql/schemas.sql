-- Customers Table
CREATE TABLE customers (
    customer_id INT PRIMARY KEY,
    customer_name VARCHAR(150) NOT NULL,
    email VARCHAR(150) NOT NULL UNIQUE,
    phone_number VARCHAR(20) NOT NULL,
    city VARCHAR(100) NOT NULL,
    registration_date DATE NOT NULL,
    membership_type VARCHAR(30) NOT NULL DEFAULT 'Regular',
    loyalty_points INT NOT NULL DEFAULT 0,
    CONSTRAINT chk_membership CHECK (membership_type IN ('Regular', 'Silver', 'Gold', 'Platinum')),
    CONSTRAINT chk_loyalty_points CHECK (loyalty_points >= 0)
);

-- Bookings Table
CREATE TABLE bookings (
    booking_id INT PRIMARY KEY,
    customer_id INT NOT NULL,
    event_name VARCHAR(150) NOT NULL,
    event_category VARCHAR(50) NOT NULL,
    venue VARCHAR(150) NOT NULL,
    booking_date DATE NOT NULL,
    event_date DATE NOT NULL,
    ticket_price DECIMAL(10,2) NOT NULL,
    tickets_booked INT NOT NULL,
    booking_status VARCHAR(30) NOT NULL DEFAULT 'Pending',
    payment_method VARCHAR(50) NOT NULL,
    CONSTRAINT fk_customer FOREIGN KEY (customer_id) REFERENCES customers(customer_id) ON DELETE CASCADE,
    CONSTRAINT chk_event_category CHECK (event_category IN ('Movie', 'Concert', 'Sports', 'Conference', 'Stand-up Comedy')),
    CONSTRAINT chk_booking_status CHECK (booking_status IN ('Confirmed', 'Pending', 'Cancelled', 'Refunded')),
    CONSTRAINT chk_payment_method CHECK (payment_method IN ('Credit Card', 'Debit Card', 'UPI', 'Wallet', 'Net Banking')),
    CONSTRAINT chk_tickets_booked CHECK (tickets_booked > 0),
    CONSTRAINT chk_ticket_price CHECK (ticket_price >= 0.00),
    CONSTRAINT chk_event_booking_dates CHECK (event_date >= booking_date)
);
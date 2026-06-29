-- Use Case 3 – Database Governance

-- Task A – Trigger: Date Validation
CREATE OR REPLACE FUNCTION check_booking_dates()
RETURNS TRIGGER AS $$
BEGIN
    IF NEW.event_date < NEW.booking_date THEN
        RAISE EXCEPTION 'Validation Failed: Event date cannot be earlier than booking date.';
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_validate_booking_dates
BEFORE INSERT OR UPDATE ON bookings
FOR EACH ROW
EXECUTE FUNCTION check_booking_dates();


-- Task B – Audit Trigger
CREATE TABLE booking_audit (
    audit_id SERIAL PRIMARY KEY,
    booking_id INT,
    previous_status VARCHAR(30),
    updated_status VARCHAR(30),
    modified_timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    modified_by VARCHAR(100)
);

CREATE OR REPLACE FUNCTION log_booking_status_changes()
RETURNS TRIGGER AS $$
BEGIN
    IF OLD.booking_status IS DISTINCT FROM NEW.booking_status THEN
        INSERT INTO booking_audit (booking_id, previous_status, updated_status, modified_by)
        VALUES (OLD.booking_id, OLD.booking_status, NEW.booking_status, CURRENT_USER);
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_audit_booking_status
AFTER UPDATE ON bookings
FOR EACH ROW
EXECUTE FUNCTION log_booking_status_changes();


-- Task C – TCL Scenario
BEGIN TRANSACTION;

-- savepoint before making changes
SAVEPOINT before_price_update;

-- accidentally update the wrong category (e.g., Movie instead of Concert)
UPDATE bookings
SET ticket_price = ticket_price * 1.15
WHERE event_category = 'Movie';

-- realize the mistake and rollback to the savepoint
ROLLBACK TO SAVEPOINT before_price_update;

-- apply the correct update
UPDATE bookings
SET ticket_price = ticket_price * 1.15
WHERE event_category = 'Concert';

-- finalize and lock in the changes
COMMIT;



-- Task D – DCL: Roles and Permissions
-- 1. Creating Roles
CREATE ROLE customer_support;
CREATE ROLE finance_team;

-- 2. Granting Permissions to Customer Support
GRANT SELECT ON bookings TO customer_support;
GRANT UPDATE (booking_status) ON bookings TO customer_support;

-- 3. Granting Permissions to Finance Team
GRANT SELECT, INSERT, UPDATE ON bookings TO finance_team;
GRANT SELECT, INSERT, UPDATE ON customers TO finance_team;

-- 4. Demonstrate REVOKE 
REVOKE INSERT, DELETE ON bookings FROM customer_support;
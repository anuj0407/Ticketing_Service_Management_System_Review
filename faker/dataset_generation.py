import csv
from faker import Faker
import random

fake_obj = Faker()

# Total record length as per files
customer_record_length = 1000
booking_record_length = 15000

# Dataset 1 – Customers generation
customers_file_path = r"data\customers.csv"
customer_headers = ["customer_id", "customer_name", "email", "phone_number", "city", "registration_date", "membership_type", "loyalty_points"]

membership_types = ["Regular", "Silver", "Gold", "Platinum"]

with open(customers_file_path, "w", newline="", encoding="utf-8") as f:
    write = csv.writer(f)
    write.writerow(customer_headers)

    for i in range(1, customer_record_length + 1):
        customer_id = i
        customer_name = fake_obj.name()
        email = f"user{i}_{fake_obj.domain_name()}"
        phone_number = fake_obj.numerify(text="###-###-####")
        city = fake_obj.city()
        
        date_obj = fake_obj.date_time_between(start_date='-3y', end_date='now')
        registration_date = date_obj.strftime("%Y-%m-%d")
        
        membership_type = random.choice(membership_types)
        loyalty_points = random.randint(0, 5000)

        write.writerow([
            customer_id,
            customer_name,
            email,
            phone_number,
            city,
            registration_date,
            membership_type,
            loyalty_points
        ])

# Dataset 2 – Bookings generation
bookings_file_path = r"data\bookings.csv"
booking_headers = [
    "booking_id", "customer_id", "event_name", "event_category", "venue", 
    "booking_date", "event_date", "ticket_price", "tickets_booked", 
    "booking_status", "payment_method"
]

event_categories = ["Movie", "Concert", "Sports", "Conference", "Stand-up Comedy"]
booking_statuses = ["Confirmed", "Pending", "Cancelled", "Refunded"]
payment_methods = ["Credit Card", "Debit Card", "UPI", "Wallet", "Net Banking"]

with open(bookings_file_path, "w", newline="", encoding="utf-8") as f:
    write = csv.writer(f)
    write.writerow(booking_headers)

    for i in range(1, booking_record_length + 1):
        booking_id = i
        customer_id = random.randint(1, 1000)
        event_name = fake_obj.word()
        event_category = random.choice(event_categories)
        venue = fake_obj.street_name()
        
        b_date_obj = fake_obj.date_time_between(start_date='-2y', end_date='now')
        e_date_obj = fake_obj.date_time_between(start_date='-2y', end_date='now')
        
        if e_date_obj < b_date_obj:
            b_date_obj, e_date_obj = e_date_obj, b_date_obj
            
        booking_date = b_date_obj.strftime("%Y-%m-%d")
        event_date = e_date_obj.strftime("%Y-%m-%d")
        
        ticket_price = round(random.uniform(10.00, 500.00), 2)
        tickets_booked = random.randint(1, 10)
        booking_status = random.choice(booking_statuses)
        payment_method = random.choice(payment_methods)

        write.writerow([
            booking_id,
            customer_id,
            event_name,
            event_category,
            venue,
            booking_date,
            event_date,
            ticket_price,
            tickets_booked,
            booking_status,
            payment_method
        ])

print("File generated successfully")
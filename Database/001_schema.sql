-- ============================================================
-- EDEN LAUNDERETTE DATABASE
-- PostgreSQL DDL
-- ============================================================
-- ============================================================
-- 1. CUSTOMERS
-- ============================================================
CREATE TABLE customers (
customer_id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
customer_number VARCHAR(20) NOT NULL UNIQUE,
first_name VARCHAR(100) NOT NULL,
last_name VARCHAR(100) NOT NULL,
contact_number VARCHAR(30) NOT NULL,
email VARCHAR(150),
date_registered DATE NOT NULL DEFAULT CURRENT_DATE,
is_active BOOLEAN NOT NULL DEFAULT TRUE,
created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);
-- ============================================================
-- 2. CUSTOMER ADDRESSES
-- ============================================================
CREATE TABLE customer_addresses (
address_id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
customer_id INT NOT NULL,
address_type VARCHAR(30) NOT NULL DEFAULT 'Home',
address_line1 VARCHAR(200) NOT NULL,
address_line2 VARCHAR(200),
suburb VARCHAR(100),
city VARCHAR(100) NOT NULL,
province VARCHAR(100),
postal_code VARCHAR(20),
is_default BOOLEAN NOT NULL DEFAULT FALSE,
created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
CONSTRAINT fk_customer_addresses_customer
FOREIGN KEY (customer_id)
REFERENCES customers(customer_id)
ON DELETE CASCADE,
CONSTRAINT chk_address_type
CHECK (address_type IN ('Home', 'Work', 'Other'))
);
-- ============================================================
-- 3. USER ACCOUNTS
-- ============================================================
CREATE TABLE user_accounts (
account_id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
customer_id INT NOT NULL UNIQUE,
username VARCHAR(100) NOT NULL UNIQUE,
password_hash VARCHAR(255) NOT NULL,
is_active BOOLEAN NOT NULL DEFAULT TRUE,
last_login TIMESTAMP,
created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
CONSTRAINT fk_user_accounts_customer
FOREIGN KEY (customer_id)
REFERENCES customers(customer_id)
ON DELETE CASCADE
);
-- ============================================================
-- 4. EMPLOYEES
-- ============================================================
CREATE TABLE employees (
employee_id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
employee_number VARCHAR(20) NOT NULL UNIQUE,
first_name VARCHAR(100) NOT NULL,
last_name VARCHAR(100) NOT NULL,
contact_number VARCHAR(30),
email VARCHAR(150),
employee_role VARCHAR(50) NOT NULL,
is_active BOOLEAN NOT NULL DEFAULT TRUE,
created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
CONSTRAINT chk_employee_role
CHECK (
employee_role IN (
'Administrator',
'Laundry Staff',
'Cashier',
'Delivery Driver',
'Manager'
)
)
);
-- ============================================================
-- 5. SERVICES
-- ============================================================
CREATE TABLE services (
service_id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
service_code VARCHAR(20) NOT NULL UNIQUE,
service_name VARCHAR(100) NOT NULL,
description TEXT,
price_per_item DECIMAL(10,2) NOT NULL,
is_active BOOLEAN NOT NULL DEFAULT TRUE,
created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
CONSTRAINT chk_service_price
CHECK (price_per_item >= 0)
);
-- ============================================================
-- 6. ORDERS
-- ============================================================
CREATE TABLE orders (
order_id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
order_number VARCHAR(30) NOT NULL UNIQUE,
customer_id INT NOT NULL,
received_by_employee_id INT NOT NULL,
received_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
expected_completion_date DATE NOT NULL,
order_status VARCHAR(50) NOT NULL DEFAULT 'Received',
estimated_total DECIMAL(10,2) NOT NULL DEFAULT 0,
final_total DECIMAL(10,2),
special_instructions TEXT,
completed_at TIMESTAMP,
created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
CONSTRAINT fk_orders_customer
FOREIGN KEY (customer_id)
REFERENCES customers(customer_id),
CONSTRAINT fk_orders_employee
FOREIGN KEY (received_by_employee_id)
REFERENCES employees(employee_id),
CONSTRAINT chk_order_status
CHECK (
order_status IN (
'Received',
'Processing',
'Ready for Collection',
'Ready for Delivery',
'Dispatched',
'Completed',
'Cancelled'
)
),
CONSTRAINT chk_estimated_total
CHECK (estimated_total >= 0),
CONSTRAINT chk_final_total
CHECK (final_total IS NULL OR final_total >= 0)
);
-- ============================================================
-- 7. ORDER ITEMS
-- ============================================================
CREATE TABLE order_items (
order_item_id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
order_id INT NOT NULL,
item_type VARCHAR(100) NOT NULL,
quantity INT NOT NULL,
condition_notes TEXT,
item_notes TEXT,
created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
CONSTRAINT fk_order_items_order
FOREIGN KEY (order_id)
REFERENCES orders(order_id)
ON DELETE CASCADE,
CONSTRAINT chk_item_quantity
CHECK (quantity > 0)
);
-- ============================================================
-- 8. ORDER ITEM SERVICES
-- ============================================================
CREATE TABLE order_item_services (
order_item_service_id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
order_item_id INT NOT NULL,
service_id INT NOT NULL,
quantity INT NOT NULL,
unit_price DECIMAL(10,2) NOT NULL,
line_total DECIMAL(10,2) NOT NULL,
CONSTRAINT fk_order_item_services_item
FOREIGN KEY (order_item_id)
REFERENCES order_items(order_item_id)
ON DELETE CASCADE,
CONSTRAINT fk_order_item_services_service
FOREIGN KEY (service_id)
REFERENCES services(service_id),
CONSTRAINT chk_service_quantity
CHECK (quantity > 0),
CONSTRAINT chk_unit_price
CHECK (unit_price >= 0),
CONSTRAINT chk_line_total
CHECK (line_total >= 0),
CONSTRAINT uq_order_item_service
UNIQUE (order_item_id, service_id)
);
-- ============================================================
-- 9. ORDER STATUS HISTORY
-- ============================================================
CREATE TABLE order_status_history (
status_history_id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
order_id INT NOT NULL,
status VARCHAR(50) NOT NULL,
changed_by_employee_id INT NOT NULL,
status_date TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
notes TEXT,
CONSTRAINT fk_status_history_order
FOREIGN KEY (order_id)
REFERENCES orders(order_id)
ON DELETE CASCADE,
CONSTRAINT fk_status_history_employee
FOREIGN KEY (changed_by_employee_id)
REFERENCES employees(employee_id),
CONSTRAINT chk_history_status
CHECK (
status IN (
'Received',
'Processing',
'Ready for Collection',
'Ready for Delivery',
'Dispatched',
'Completed',
'Cancelled'
)
)
);
-- ============================================================
-- 10. COLLECTION AND DELIVERY
-- ============================================================
CREATE TABLE collection_delivery (
collection_delivery_id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
order_id INT NOT NULL,
employee_id INT,
transaction_type VARCHAR(20) NOT NULL,
status VARCHAR(30) NOT NULL DEFAULT 'Scheduled',
address_id INT NOT NULL,
scheduled_datetime TIMESTAMP NOT NULL,
actual_datetime TIMESTAMP,
proof_of_delivery VARCHAR(255),
notes TEXT,
CONSTRAINT fk_collection_delivery_order
FOREIGN KEY (order_id)
REFERENCES orders(order_id)
ON DELETE CASCADE,
CONSTRAINT fk_collection_delivery_employee
FOREIGN KEY (employee_id)
REFERENCES employees(employee_id),
CONSTRAINT fk_collection_delivery_address
FOREIGN KEY (address_id)
REFERENCES customer_addresses(address_id),
CONSTRAINT chk_transaction_type
CHECK (
transaction_type IN ('Collection', 'Delivery')
),
CONSTRAINT chk_delivery_status
CHECK (
status IN (
'Scheduled',
'Assigned',
'In Progress',
'Completed',
'Failed',
'Cancelled'
)
)
);
-- ============================================================
-- 11. PAYMENTS
-- ============================================================
CREATE TABLE payments (
payment_id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
order_id INT NOT NULL,
receipt_number VARCHAR(30) NOT NULL UNIQUE,
amount DECIMAL(10,2) NOT NULL,
payment_method VARCHAR(30) NOT NULL,
payment_status VARCHAR(30) NOT NULL DEFAULT 'Paid',
payment_date TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
recorded_by_employee_id INT NOT NULL,
notes TEXT,
CONSTRAINT fk_payments_order
FOREIGN KEY (order_id)
REFERENCES orders(order_id),
CONSTRAINT fk_payments_employee
FOREIGN KEY (recorded_by_employee_id)
REFERENCES employees(employee_id),
CONSTRAINT chk_payment_amount
CHECK (amount > 0),
CONSTRAINT chk_payment_method
CHECK (
payment_method IN (
'Cash',
'Card',
'EFT',
'Online'
)
),
CONSTRAINT chk_payment_status
CHECK (
payment_status IN (
'Paid',
'Pending',
'Failed',
'Refunded'
)
)
);
-- ============================================================
-- 12. NOTIFICATIONS
-- ============================================================
CREATE TABLE notifications (
notification_id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
customer_id INT NOT NULL,
order_id INT,
notification_type VARCHAR(50) NOT NULL,
delivery_channel VARCHAR(20) NOT NULL,
message TEXT NOT NULL,
notification_status VARCHAR(20) NOT NULL DEFAULT 'Pending',
sent_at TIMESTAMP,
created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
CONSTRAINT fk_notifications_customer
FOREIGN KEY (customer_id)
REFERENCES customers(customer_id)
ON DELETE CASCADE,
CONSTRAINT fk_notifications_order
FOREIGN KEY (order_id)
REFERENCES orders(order_id)
ON DELETE SET NULL,
CONSTRAINT chk_notification_channel
CHECK (
delivery_channel IN (
'SMS',
'Email',
'Mobile App'
)
),
CONSTRAINT chk_notification_status
CHECK (
notification_status IN (
'Pending',
'Sent',
'Delivered',
'Failed',
'Read'
)
)
);

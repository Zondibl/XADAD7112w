-- ============================================================
-- TEST DATA
-- ============================================================
-- ============================================================
-- 1. CUSTOMERS
-- ============================================================
INSERT INTO customers
(customer_number, first_name, last_name, contact_number, email)
VALUES
('CUS-00001', 'John', 'Smith', '0825551001', 'john.smith@example.com'),
('CUS-00002', 'Thandi', 'Mokoena', '0825551002', 'thandi.mokoena@example.com'),
('CUS-00003', 'Michael', 'Naidoo', '0825551003', 'michael.naidoo@example.com'),
('CUS-00004', 'Sarah', 'Dlamini', '0825551004', 'sarah.dlamini@example.com'),
('CUS-00005', 'David', 'Williams', '0825551005', 'david.williams@example.com');
-- ============================================================
-- 2. CUSTOMER ADDRESSES
-- ============================================================
INSERT INTO customer_addresses
(customer_id, address_type, address_line1, suburb, city, province, postal_code, is_default)
VALUES
(1, 'Home', '15 Main Street', 'Sandton', 'Johannesburg', 'Gauteng', '2196', TRUE),
(2, 'Home', '22 Oak Avenue', 'Randburg', 'Johannesburg', 'Gauteng', '2194', TRUE),
(3, 'Home', '8 Pine Road', 'Rosebank', 'Johannesburg', 'Gauteng', '2196', TRUE),
(4, 'Work', '45 Church Street', 'Centurion', 'Pretoria', 'Gauteng', '0046', TRUE),
(5, 'Home', '12 Market Road', 'Midrand', 'Johannesburg', 'Gauteng', '1685', TRUE);
-- ============================================================
-- 3. USER ACCOUNTS
-- ============================================================
INSERT INTO user_accounts
(customer_id, username, password_hash)
VALUES
(1, 'john.smith', 'TEST_HASH_001'),
(2, 'thandi.mokoena', 'TEST_HASH_002'),
(3, 'michael.naidoo', 'TEST_HASH_003'),
(4, 'sarah.dlamini', 'TEST_HASH_004'),
(5, 'david.williams', 'TEST_HASH_005');
-- ============================================================
-- 4. EMPLOYEES
-- ============================================================
INSERT INTO employees
(employee_number, first_name, last_name, contact_number, email, employee_role)
VALUES
('EMP-001', 'Lerato', 'Molefe', '0835552001', 'lerato@edenlaunderette.co.za', 'Administrator'),
('EMP-002', 'Peter', 'Nkosi', '0835552002', 'peter@edenlaunderette.co.za', 'Laundry Staff'),
('EMP-003', 'Nomsa', 'Khumalo', '0835552003', 'nomsa@edenlaunderette.co.za', 'Cashier'),
('EMP-004', 'Sipho', 'Mthembu', '0835552004', 'sipho@edenlaunderette.co.za', 'Delivery Driver'),
('EMP-005', 'Amanda', 'Pillay', '0835552005', 'amanda@edenlaunderette.co.za', 'Manager');
-- ============================================================
-- 5. SERVICES
-- ============================================================
INSERT INTO services
(service_code, service_name, description, price_per_item)
VALUES
('WASH', 'Washing', 'Standard washing service', 25.00),
('IRON', 'Ironing', 'Professional ironing service', 20.00),
('FOLD', 'Folding', 'Folding and packaging service', 10.00),
('WASHIRON', 'Washing and Ironing', 'Washing followed by ironing', 40.00),
('DRYCLEAN', 'Dry Cleaning', 'Professional dry cleaning service', 60.00);
-- ============================================================
-- 6. ORDERS
-- ============================================================
INSERT INTO orders
(order_number, customer_id, received_by_employee_id,
received_at, expected_completion_date, order_status,
estimated_total, final_total, special_instructions)
VALUES
(
'EDN-000125',
1,
2,
'2026-08-27 09:15:00',
'2026-08-27',
'Processing',
400.00,
NULL,
'Please keep shirts separate.'
),
(
'EDN-000126',
2,
2,
'2026-08-27 10:30:00',
'2026-08-28',
'Ready for Collection',
250.00,
250.00,
'Customer will collect.'
),
(
'EDN-000127',
3,
5,
'2026-08-28 08:45:00',
'2026-08-29',
'Ready for Delivery',
300.00,
300.00,
'Delivery required.'
),
(
'EDN-000128',
4,
2,
'2026-08-28 11:20:00',
'2026-08-28',
'Completed',
180.00,
180.00,
'Same-day service.'
),
(
'EDN-000129',
5,
2,
'2026-08-29 14:10:00',
'2026-08-30',
'Received',
200.00,
NULL,
'Handle with care.'
);
-- ============================================================
-- 7. ORDER ITEMS
-- ============================================================
INSERT INTO order_items
(order_id, item_type, quantity, condition_notes, item_notes)
VALUES
(1, 'Shirts', 8, 'Good condition', 'White and blue shirts'),
(2, 'Trousers', 5, 'Good condition', 'Formal trousers'),
(3, 'Dresses', 3, 'Good condition', 'Delicate material'),
(4, 'Blankets', 2, 'Good condition', 'Large blankets'),
(5, 'School Uniforms', 5, 'Good condition', 'School uniforms');
-- ============================================================
-- 8. ORDER ITEM SERVICES
-- ============================================================
INSERT INTO order_item_services
(order_item_id, service_id, quantity, unit_price, line_total)
VALUES
(1, 4, 8, 40.00, 320.00),
(2, 1, 5, 25.00, 125.00),
(3, 5, 3, 60.00, 180.00),
(4, 1, 2, 25.00, 50.00),
(5, 2, 5, 20.00, 100.00);
-- ============================================================
-- 9. ORDER STATUS HISTORY
-- ============================================================
INSERT INTO order_status_history
(order_id, status, changed_by_employee_id, status_date, notes)
VALUES
(1, 'Received', 2, '2026-08-27 09:15:00', 'Order received from customer.'),
(2, 'Processing', 2, '2026-08-27 11:00:00', 'Laundry processing started.'),
(3, 'Ready for Delivery', 5, '2026-08-29 09:00:00', 'Laundry completed and prepared for delivery.'),
(4, 'Completed', 2, '2026-08-28 16:30:00', 'Customer order completed.'),
(5, 'Received', 2, '2026-08-29 14:10:00', 'Order received and awaiting processing.');
-- ============================================================
-- 10. COLLECTION / DELIVERY
-- ============================================================
INSERT INTO collection_delivery
(order_id, employee_id, transaction_type, status,
address_id, scheduled_datetime, actual_datetime,
proof_of_delivery, notes)
VALUES
(
1, 4, 'Delivery', 'Scheduled',
1, '2026-08-27 17:00:00', NULL,
NULL, 'Same-day delivery.'
),
(
2, 4, 'Collection', 'Completed',
2, '2026-08-28 15:00:00',
'2026-08-28 15:20:00',
'COLLECT-126',
'Customer collection completed.'
),
(
3, 4, 'Delivery', 'Completed',
3, '2026-08-29 14:00:00',
'2026-08-29 14:25:00',
'POD-127',
'Delivered to customer.'
),
(
4, 4, 'Delivery', 'Completed',
4, '2026-08-28 16:00:00',
'2026-08-28 16:20:00',
'POD-128',
'Delivered successfully.'
),
(
5, 4, 'Delivery', 'Scheduled',
5, '2026-08-30 13:00:00',
NULL,
NULL,
'Delivery scheduled.'
);
-- ============================================================
-- 11. PAYMENTS
-- ============================================================
INSERT INTO payments
(order_id, receipt_number, amount, payment_method,
payment_status, payment_date, recorded_by_employee_id, notes)
VALUES
(
1, 'REC-000125', 200.00, 'Cash',
'Paid', '2026-08-27 09:30:00', 3,
'Part payment received.'
),
(
2, 'REC-000126', 250.00, 'Card',
'Paid', '2026-08-28 14:30:00', 3,
'Payment completed.'
),
(
3, 'REC-000127', 300.00, 'EFT',
'Paid', '2026-08-29 09:30:00', 3,
'EFT payment received.'
),
(
4, 'REC-000128', 180.00, 'Cash',
'Paid', '2026-08-28 16:00:00', 3,
'Paid on collection.'
),
(
5, 'REC-000129', 100.00, 'Card',
'Paid', '2026-08-29 14:30:00', 3,
'Deposit received.'
);
-- ============================================================
-- 12. NOTIFICATIONS
-- ============================================================
INSERT INTO notifications
(customer_id, order_id, notification_type,
delivery_channel, message, notification_status, sent_at)
VALUES
(
1, 1, 'Order Received',
'SMS',
'Your Eden Launderette order EDN-000125 has been received.',
'Sent',
'2026-08-27 09:20:00'
),
(
2, 2, 'Order Ready',
'Email',
'Your laundry order EDN-000126 is ready for collection.',
'Sent',
'2026-08-28 13:00:00'
),
(
3, 3, 'Dispatched',
'Mobile App',
'Your order EDN-000127 has been dispatched for delivery.',
'Sent',
'2026-08-29 13:30:00'
),
(
4, 4, 'Delivered',
'SMS',
'Your order EDN-000128 has been delivered.',
'Delivered',
'2026-08-28 16:25:00'
),
(
5, 5, 'Payment Outstanding',
'Email',
'Your Eden Launderette order EDN-000129 has an outstanding balance.',
'Sent',
'2026-08-29 15:00:00'
);

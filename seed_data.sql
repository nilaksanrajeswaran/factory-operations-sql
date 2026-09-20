-- ============================================================
-- Factory Operations Analytics Database
-- Seed Data
-- ============================================================


-- Employees
INSERT INTO employees
(employee_id, first_name, last_name, job_title, hire_date, status)
VALUES
(101, 'John', 'Carter', 'Production Supervisor', '2019-03-15', 'Active'),
(102, 'Sarah', 'Patel', 'Production Supervisor', '2020-07-08', 'Active'),
(103, 'Michael', 'Chen', 'Production Operator', '2021-02-11', 'Active'),
(104, 'Emily', 'Wilson', 'Production Operator', '2022-09-19', 'Active'),
(105, 'David', 'Singh', 'Warehouse Associate', '2023-01-10', 'Active'),
(106, 'Lisa', 'Brown', 'Warehouse Associate', '2021-11-05', 'Active');


-- Products
INSERT INTO products
(product_id, sku, product_name, category, unit_cost)
VALUES
(1, 'WIN-100', 'Standard Window', 'Window', 125.00),
(2, 'WIN-200', 'Premium Window', 'Window', 185.00),
(3, 'DOR-100', 'Patio Door', 'Door', 350.00),
(4, 'WIN-300', 'Basement Window', 'Window', 95.00),
(5, 'DOR-200', 'French Door', 'Door', 525.00),
(6, 'WIN-400', 'Custom Window', 'Window', NULL);


-- Production Lines
INSERT INTO production_lines
(line_id, line_name, supervisor_id)
VALUES
(1, 'Line A', 101),
(2, 'Line B', 102),
(3, 'Line C', 101);


-- Inventory
INSERT INTO inventory
(inventory_id, product_id, quantity, warehouse_location)
VALUES
(1, 1, 250, 'A-01'),
(2, 2, 75, 'A-02'),
(3, 3, 40, 'B-01'),
(4, 4, 180, 'A-03'),
(5, 5, 25, 'B-02');


-- Production Runs
INSERT INTO production_runs
(run_id, line_id, product_id, start_time, end_time, units_produced)
VALUES
(1, 1, 1, '2026-09-10 07:00', '2026-09-10 11:00', 500),
(2, 1, 2, '2026-09-10 12:00', '2026-09-10 16:00', 420),
(3, 2, 1, '2026-09-10 07:30', '2026-09-10 12:30', 550),
(4, 2, 4, '2026-09-10 13:00', '2026-09-10 17:00', 390),
(5, 3, 3, '2026-09-10 07:00', '2026-09-10 12:00', 300),
(6, 3, 5, '2026-09-10 13:00', '2026-09-10 18:00', 240),
(7, 1, 1, '2026-09-11 07:00', '2026-09-11 11:30', 525),
(8, 2, 2, '2026-09-11 07:00', '2026-09-11 12:00', 510),
(9, 3, 4, '2026-09-11 07:30', '2026-09-11 13:00', 330);


-- Defects
INSERT INTO defects
(defect_id, run_id, defect_type, defective_units)
VALUES
(1, 1, 'Cracked frame', 8),
(2, 1, 'Misalignment', 4),
(3, 2, 'Seal defect', 12),
(4, 3, 'Cracked frame', 5),
(5, 4, 'Misalignment', 7),
(6, 5, 'Surface damage', 15),
(7, 5, 'Misalignment', 6),
(8, 6, 'Surface damage', 18),
(9, 7, 'Cracked frame', 4),
(10, 8, 'Seal defect', 6),
(11, 9, 'Misalignment', 14);


-- Downtime
INSERT INTO downtime
(downtime_id, line_id, start_time, end_time, reason)
VALUES
(1, 1, '2026-09-10 09:00', '2026-09-10 09:30', 'Machine adjustment'),
(2, 1, '2026-09-10 14:00', '2026-09-10 14:45', 'Material shortage'),
(3, 2, '2026-09-10 10:00', '2026-09-10 10:20', 'Sensor failure'),
(4, 2, '2026-09-10 15:00', '2026-09-10 15:15', 'Maintenance'),
(5, 3, '2026-09-10 09:00', '2026-09-10 10:15', 'Machine failure'),
(6, 3, '2026-09-10 15:00', '2026-09-10 16:00', 'Machine failure'),
(7, 1, '2026-09-11 09:30', '2026-09-11 09:45', 'Maintenance'),
(8, 2, '2026-09-11 10:00', '2026-09-11 10:30', 'Material shortage'),
(9, 3, '2026-09-11 09:00', '2026-09-11 10:30', 'Machine failure');


-- Orders
INSERT INTO orders
(order_id, order_time, promised_ship_time, actual_ship_time, shift)
VALUES
(1, '2026-09-10 07:30', '2026-09-10 15:00', '2026-09-10 14:45', 'Day'),
(2, '2026-09-10 08:15', '2026-09-10 16:00', '2026-09-10 17:20', 'Day'),
(3, '2026-09-10 15:30', '2026-09-10 23:00', '2026-09-10 22:40', 'Evening'),
(4, '2026-09-10 16:10', '2026-09-10 23:30', '2026-09-11 00:15', 'Evening'),
(5, '2026-09-10 23:15', '2026-09-11 07:00', '2026-09-11 06:30', 'Night'),
(6, '2026-09-11 08:00', '2026-09-11 16:00', NULL, 'Day');


-- Order Items
INSERT INTO order_items
(order_item_id, order_id, product_id, quantity)
VALUES
(1, 1, 1, 2),
(2, 1, 3, 1),
(3, 2, 2, 4),
(4, 2, 4, 2),
(5, 3, 1, 5),
(6, 3, 5, 1),
(7, 4, 3, 3),
(8, 5, 4, 6),
(9, 5, 2, 2),
(10, 6, 1, 4);


-- Picking Exceptions
INSERT INTO picking_exceptions
(exception_id, order_item_id, exception_type)
VALUES
(1, 1, 'Wrong location'),
(2, 3, 'Quantity mismatch'),
(3, 3, 'Damaged item'),
(4, 4, 'Out of stock'),
(5, 5, 'Wrong location'),
(6, 5, 'Quantity mismatch'),
(7, 5, 'Damaged item'),
(8, 8, 'Out of stock'),
(9, 8, 'Wrong location'),
(10, 10, 'Quantity mismatch');
-- ============================================================
-- Factory Operations Analytics Database
-- Schema
-- ============================================================


-- 1. Employees
CREATE TABLE employees (
    employee_id INTEGER PRIMARY KEY,
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    job_title VARCHAR(100),
    hire_date DATE,
    status VARCHAR(20)
);


-- 2. Products
CREATE TABLE products (
    product_id INTEGER PRIMARY KEY,
    sku VARCHAR(20),
    product_name VARCHAR(100),
    category VARCHAR(50),
    unit_cost DECIMAL(10,2) CHECK (unit_cost >= 0)
);


-- 3. Production Lines
CREATE TABLE production_lines (
    line_id INTEGER PRIMARY KEY,
    line_name VARCHAR(50),
    supervisor_id INTEGER REFERENCES employees(employee_id)
);


-- 4. Inventory
CREATE TABLE inventory (
    inventory_id INTEGER PRIMARY KEY,
    product_id INTEGER REFERENCES products(product_id),
    quantity INTEGER CHECK (quantity >= 0),
    warehouse_location VARCHAR(20)
);


-- 5. Production Runs
CREATE TABLE production_runs (
    run_id INTEGER PRIMARY KEY,
    line_id INTEGER REFERENCES production_lines(line_id),
    product_id INTEGER REFERENCES products(product_id),
    start_time TIMESTAMP,
    end_time TIMESTAMP,
    units_produced INTEGER CHECK (units_produced >= 0),
	CHECK (end_time > start_time)
);


-- 6. Defects
CREATE TABLE defects (
    defect_id INTEGER PRIMARY KEY,
    run_id INTEGER REFERENCES production_runs(run_id),
    defect_type VARCHAR(50),
    defective_units INTEGER CHECK (defective_units >= 0 )
);


-- 7. Downtime
CREATE TABLE downtime (
    downtime_id INTEGER PRIMARY KEY,
    line_id INTEGER REFERENCES production_lines(line_id),
    start_time TIMESTAMP,
    end_time TIMESTAMP,
    reason VARCHAR(50),
	CHECK (end_time > start_time)
);


-- 8. Orders
CREATE TABLE orders (
    order_id INTEGER PRIMARY KEY,
    order_time TIMESTAMP,
    promised_ship_time TIMESTAMP,
    actual_ship_time TIMESTAMP,
    shift VARCHAR(20)
);


-- 9. Order Items
CREATE TABLE order_items (
    order_item_id INTEGER PRIMARY KEY,
    order_id INTEGER REFERENCES orders(order_id),
    product_id INTEGER REFERENCES products(product_id),
    quantity INTEGER CHECK (quantity > 0)
);


-- 10. Picking Exceptions
CREATE TABLE picking_exceptions (
    exception_id INTEGER PRIMARY KEY,
    order_item_id INTEGER REFERENCES order_items(order_item_id),
    exception_type VARCHAR(50)
);
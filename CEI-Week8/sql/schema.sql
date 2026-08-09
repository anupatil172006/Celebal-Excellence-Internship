-- ============================================================
-- E-Commerce Analytics System
-- Database Schema
-- SQLite
-- ============================================================

PRAGMA foreign_keys = ON;

-- ============================================================
-- Customers
-- ============================================================

CREATE TABLE IF NOT EXISTS customers (
    customer_id TEXT PRIMARY KEY,
    customer_name TEXT NOT NULL,
    email TEXT,
    registration_date DATE,
    customer_type TEXT
);

-- ============================================================
-- Products
-- ============================================================

CREATE TABLE IF NOT EXISTS products (
    product_id TEXT PRIMARY KEY,
    product_name TEXT NOT NULL,
    category TEXT,
    subcategory TEXT,
    cost_price REAL
);

-- ============================================================
-- Orders
-- ============================================================

CREATE TABLE IF NOT EXISTS orders (
    order_id TEXT PRIMARY KEY,
    customer_id TEXT,
    order_date TEXT,
    status TEXT,
    region_code TEXT,

    FOREIGN KEY (customer_id)
        REFERENCES customers(customer_id)
);

-- ============================================================
-- Order Items
-- ============================================================

CREATE TABLE IF NOT EXISTS order_items (
    item_id TEXT PRIMARY KEY,
    order_id TEXT,
    product_id TEXT,
    quantity INTEGER,
    unit_price REAL,
    discount_percent REAL,

    FOREIGN KEY (order_id)
        REFERENCES orders(order_id),

    FOREIGN KEY (product_id)
        REFERENCES products(product_id)
);
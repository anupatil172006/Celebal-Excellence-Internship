import sqlite3
import pandas as pd

conn = sqlite3.connect("ecommerce.db")
cursor = conn.cursor()

cursor.execute("PRAGMA foreign_keys = ON;")

cursor.executescript("""
DROP TABLE IF EXISTS order_items;
DROP TABLE IF EXISTS orders;
DROP TABLE IF EXISTS products;
DROP TABLE IF EXISTS customers;
""")

cursor.execute("""
CREATE TABLE customers(
customer_id TEXT PRIMARY KEY,
customer_name TEXT NOT NULL,
email TEXT,
registration_date DATE,
customer_type TEXT
);

""")

# Creating products table
cursor.execute("""
CREATE TABLE products(
product_id TEXT PRIMARY KEY,
product_name TEXT NOT NULL,
category TEXT,
subcategory TEXT,
cost_price REAL
);
""")

#Creating table orders
cursor.execute("""
CREATE TABLE orders(
order_id TEXT PRIMARY KEY,
customer_id TEXT,
order_date TEXT,
status TEXT,
region_code TEXT,
FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
);
""")

#Create order items
cursor.execute("""
CREATE TABLE order_items(
item_id TEXT PRIMARY KEY,
order_id TEXT,
product_id TEXT,
quantity INTEGER,
unit_price REAL,
discount_percent REAL,

FOREIGN KEY(order_id) REFERENCES orders(order_id),
FOREIGN KEY(product_id) REFERENCES products(product_id)
);
""")

print("Tables created successfully")

# Load cleaned csv

customers = pd.read_csv("cleaned/customers_clean.csv")
products = pd.read_csv("cleaned/products_clean.csv")
orders = pd.read_csv("cleaned/orders_clean.csv")
order_items = pd.read_csv("cleaned/order_items_clean.csv")

#Inserting data
customers.to_sql(
    "customers",
    conn,
    if_exists = "append",
    index = False
)

products.to_sql(
    "products",
    conn,
    if_exists = "append",
    index = False
)

orders.to_sql(
    "orders",
    conn,
    if_exists = "append",
    index = False
)

order_items.to_sql(
    "order_items",
    conn,
    if_exists = "append",
    index = False
)

print("Data loaded successfully!")

#verifying row counts

tables = ["customers", "products", "orders", "order_items"]

for table in tables:
    cursor.execute(f"SELECT COUNT(*) FROM {table}")
    count = cursor.fetchone()[0]
    print(f"{table}:{count}")
conn.commit()
conn.close()

print("Database created successfully!")
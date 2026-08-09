import pandas as pd
import random
from faker import Faker
from datetime import datetime, timedelta
import os

# -------------------------------
# Initialization
# -------------------------------

fake = Faker()
random.seed(42)
Faker.seed(42)

# Create output folder
os.makedirs("raw", exist_ok=True)

# Dataset sizes
NUM_CUSTOMERS = 500
NUM_PRODUCTS = 500
NUM_ORDERS = 1000
NUM_ORDER_ITEMS = 3000

# -------------------------------
# Customers Dataset
# -------------------------------

customer_types = ["REGULAR", "PREMIUM", "VIP"]

customers = []

for i in range(1, NUM_CUSTOMERS + 1):

    email = fake.email()

    # 2% invalid emails
    if random.random() < 0.02:
        email = email.replace("@", "")

    customers.append({
        "customer_id": f"C{i:04d}",
        "customer_name": fake.name(),
        "email": email,
        "registration_date": fake.date_between(
            start_date="-3y",
            end_date="today"
        ),
        "customer_type": random.choice(customer_types)
    })

customers_df = pd.DataFrame(customers)

# -------------------------------
# Products Dataset
# -------------------------------

categories = {
    "Electronics": [
        "Laptop",
        "Smartphone",
        "Headphones",
        "Keyboard",
        "Mouse",
        "Speaker"
    ],
    "Clothing": [
        "T-Shirt",
        "Jeans",
        "Jacket",
        "Shoes",
        "Cap"
    ],
    "Books": [
        "Novel",
        "Dictionary",
        "Python Book",
        "SQL Guide",
        "Notebook"
    ],
    "Home": [
        "Chair",
        "Table",
        "Lamp",
        "Curtains",
        "Sofa"
    ]
}

products = []

for i in range(1, NUM_PRODUCTS + 1):

    category = random.choice(list(categories.keys()))
    product_name = random.choice(categories[category])

    # Add messy names
    if random.random() < 0.05:
        product_name = "  " + product_name.upper() + "  "

    products.append({
        "product_id": f"P{i:04d}",
        "product_name": product_name,
        "category": category,
        "subcategory": fake.word().title(),
        "cost_price": round(random.uniform(100, 5000), 2)
    })

products_df = pd.DataFrame(products)

# -------------------------------
# Orders Dataset
# -------------------------------

statuses = [
    "PLACED",
    "SHIPPED",
    "DELIVERED",
    "CANCELLED",
    "RETURNED"
]

regions = [
    "NORTH",
    "SOUTH",
    "EAST",
    "WEST"
]

orders = []

for i in range(1, NUM_ORDERS + 1):

    customer = random.choice(customers_df["customer_id"])

    # 5% NULL customer IDs
    if random.random() < 0.05:
        customer = None

    order_date = fake.date_time_between(
        start_date="-2y",
        end_date="now"
    )

    # Wrong format in some dates
    if random.random() < 0.05:
        order_date = order_date.strftime("%d-%m-%Y")
    else:
        order_date = order_date.strftime("%Y-%m-%d %H:%M:%S")

    orders.append({
        "order_id": f"O{i:05d}",
        "customer_id": customer,
        "order_date": order_date,
        "status": random.choice(statuses),
        "region_code": random.choice(regions)
    })

orders_df = pd.DataFrame(orders)

# -------------------------------
# Order Items Dataset
# -------------------------------

order_items = []

for i in range(1, NUM_ORDER_ITEMS + 1):

    quantity = random.randint(1, 5)

    # 3% negative quantities
    if random.random() < 0.03:
        quantity *= -1

    product = products_df.sample(1).iloc[0]

    order_items.append({
        "item_id": f"I{i:05d}",
        "order_id": random.choice(orders_df["order_id"]),
        "product_id": product["product_id"],
        "quantity": quantity,
        "unit_price": round(product["cost_price"] * random.uniform(1.1, 2.0), 2),
        "discount_percent": random.randint(0, 100)
    })

order_items_df = pd.DataFrame(order_items)

# -------------------------------
# Save CSV Files
# -------------------------------

customers_df.to_csv("raw/customers.csv", index=False)
products_df.to_csv("raw/products.csv", index=False)
orders_df.to_csv("raw/orders.csv", index=False)
order_items_df.to_csv("raw/order_items.csv", index=False)

print("=" * 50)
print("Datasets Generated Successfully!")
print("=" * 50)
print(f"Customers    : {len(customers_df)}")
print(f"Products     : {len(products_df)}")
print(f"Orders       : {len(orders_df)}")
print(f"Order Items  : {len(order_items_df)}")
print("\nFiles saved inside the 'raw' folder.")
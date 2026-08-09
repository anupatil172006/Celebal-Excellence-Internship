import pandas as pd
import os
import re

# -------------------------------
# Create Output Folder
# -------------------------------

os.makedirs("cleaned", exist_ok=True)

# -------------------------------
# Load Raw CSV Files
# -------------------------------

customers = pd.read_csv("raw/customers.csv")
products = pd.read_csv("raw/products.csv")
orders = pd.read_csv("raw/orders.csv")
order_items = pd.read_csv("raw/order_items.csv")

print("Customers:", customers.shape)
print("Products:", products.shape)
print("Orders:", orders.shape)
print("Order Items:", order_items.shape)


# =====================================================
# Function 1 : Clean Orders
# =====================================================

def clean_orders(df):

    # Fill missing customer IDs
    df["customer_id"] = df["customer_id"].where(
        df["customer_id"].notna(),
        None
    )

    def fix_date(date):

        if pd.isna(date):
            return None

        # Handle DD-MM-YYYY
        if isinstance(date, str):
            try:
                return pd.to_datetime(
                    date,
                    format="%d-%m-%Y"
                ).strftime("%Y-%m-%d %H:%M:%S")
            except:
                pass

        # Handle standard datetime
        try:
            return pd.to_datetime(
                date
            ).strftime("%Y-%m-%d %H:%M:%S")
        except:
            return None

    df["order_date"] = df["order_date"].apply(fix_date)

    return df


# =====================================================
# Function 2 : Clean Products
# =====================================================

def clean_products(df):

    df["product_name"] = (
        df["product_name"]
        .astype(str)
        .str.strip()
        .str.title()
    )

    return df


# =====================================================
# Function 3 : Validate Emails
# =====================================================

def validate_emails(df):

    pattern = r"^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$"

    invalid = df[
        ~df["email"].astype(str).str.match(pattern)
    ]

    return invalid


# =====================================================
# Function 4 : Referential Integrity
# =====================================================

def check_referential_integrity(orders_df, items_df):

    invalid = items_df[
        ~items_df["order_id"].isin(
            orders_df["order_id"]
        )
    ]

    return invalid


# =====================================================
# Run Cleaning
# =====================================================

orders = clean_orders(orders)

products = clean_products(products)

invalid_emails = validate_emails(customers)

invalid_order_items = check_referential_integrity(
    orders,
    order_items
)

# =====================================================
# Display Results
# =====================================================

print("\n==============================")
print("Orders After Cleaning")
print("==============================")
print(orders.head())

print("\nMissing Customer IDs :",
      orders["customer_id"].isnull().sum())

print("\n==============================")
print("Products After Cleaning")
print("==============================")
print(products.head())

print("\n==============================")
print("Invalid Emails Found")
print("==============================")
print(len(invalid_emails))

print(invalid_emails.head())

print("\n==============================")
print("Invalid Order References")
print("==============================")
print(len(invalid_order_items))

print(invalid_order_items.head())

# =====================================================
# Save Cleaned CSV Files
# =====================================================

customers.to_csv(
    "cleaned/customers_clean.csv",
    index=False
)

products.to_csv(
    "cleaned/products_clean.csv",
    index=False
)

orders.to_csv(
    "cleaned/orders_clean.csv",
    index=False
)

order_items.to_csv(
    "cleaned/order_items_clean.csv",
    index=False
)

# =====================================================
# Generate Cleaning Report
# =====================================================

report = pd.DataFrame({
    "Issue": [
        "Missing Customer IDs",
        "Invalid Emails",
        "Invalid Order References"
    ],
    "Count": [
        (orders["customer_id"] == "UNKNOWN").sum(),
        len(invalid_emails),
        len(invalid_order_items)
    ]
})

report.to_csv(
    "cleaned/issues_report.csv",
    index=False
)

print("\n===================================")
print("Cleaning Completed Successfully!")
print("===================================")

print("\nGenerated Files:")

print("customers_clean.csv")
print("products_clean.csv")
print("orders_clean.csv")
print("order_items_clean.csv")
print("issues_report.csv")
import sqlite3
import os
import argparse

DB_PATH = "ecommerce.db"
REPORT_DIR = "output/sample_reports"


# ============================================================
# CREATE REPORT DIRECTORY
# ============================================================

def create_report_directory():
    os.makedirs(REPORT_DIR, exist_ok=True)


# ============================================================
# DATABASE CONNECTION
# ============================================================

def get_connection():
    try:
        return sqlite3.connect(DB_PATH)
    except sqlite3.Error as e:
        print(f"Database connection error: {e}")
        return None


# ============================================================
# SAVE REPORT TO FILE
# ============================================================

def save_report(filename, content):
    create_report_directory()

    filepath = os.path.join(REPORT_DIR, filename)

    with open(filepath, "w", encoding="utf-8") as file:
        file.write(content)

    print(f"\nReport saved to: {filepath}")


# ============================================================
# REPORT 1: TOTAL SALES
# ============================================================

def show_total_sales():
    conn = get_connection()

    if conn is None:
        return

    query = """
    SELECT
        ROUND(
            SUM(
                quantity * unit_price *
                (1 - discount_percent / 100.0)
            ),
            2
        )
    FROM order_items;
    """

    result = conn.execute(query).fetchone()

    total_sales = result[0] if result[0] is not None else 0

    content = (
        "===== TOTAL SALES =====\n"
        f"Total Sales: ₹{total_sales:,.2f}\n"
    )

    print("\n" + content)
    save_report("total_sales.txt", content)

    conn.close()


# ============================================================
# REPORT 2: TOP 10 PRODUCTS
# ============================================================

def show_top_products():
    conn = get_connection()

    if conn is None:
        return

    query = """
    SELECT
        p.product_name,
        SUM(oi.quantity),
        ROUND(
            SUM(
                oi.quantity * oi.unit_price *
                (1 - oi.discount_percent / 100.0)
            ),
            2
        )
    FROM order_items oi
    JOIN products p
        ON oi.product_id = p.product_id
    GROUP BY p.product_id, p.product_name
    ORDER BY
        SUM(
            oi.quantity * oi.unit_price *
            (1 - oi.discount_percent / 100.0)
        ) DESC
    LIMIT 10;
    """

    rows = conn.execute(query).fetchall()

    lines = ["===== TOP 10 PRODUCTS ====="]

    if not rows:
        lines.append("No product data available.")

    for row in rows:
        lines.append(
            f"Product: {row[0]} | "
            f"Units Sold: {row[1]} | "
            f"Revenue: ₹{row[2]:,.2f}"
        )

    content = "\n".join(lines) + "\n"

    print("\n" + content)
    save_report("top_products.txt", content)

    conn.close()


# ============================================================
# REPORT 3: TOP 10 CUSTOMERS
# ============================================================

def show_top_customers():
    conn = get_connection()

    if conn is None:
        return

    query = """
    SELECT
        c.customer_id,
        c.customer_name,
        ROUND(
            SUM(
                oi.quantity * oi.unit_price *
                (1 - oi.discount_percent / 100.0)
            ),
            2
        )
    FROM customers c
    JOIN orders o
        ON c.customer_id = o.customer_id
    JOIN order_items oi
        ON o.order_id = oi.order_id
    GROUP BY c.customer_id, c.customer_name
    ORDER BY
        SUM(
            oi.quantity * oi.unit_price *
            (1 - oi.discount_percent / 100.0)
        ) DESC
    LIMIT 10;
    """

    rows = conn.execute(query).fetchall()

    lines = ["===== TOP 10 CUSTOMERS ====="]

    if not rows:
        lines.append("No customer data available.")

    for row in rows:
        lines.append(
            f"Customer ID: {row[0]} | "
            f"Name: {row[1]} | "
            f"Total Spent: ₹{row[2]:,.2f}"
        )

    content = "\n".join(lines) + "\n"

    print("\n" + content)
    save_report("top_customers.txt", content)

    conn.close()


# ============================================================
# REPORT 4: MONTHLY SALES
# ============================================================

def show_monthly_sales():
    conn = get_connection()

    if conn is None:
        return

    query = """
    SELECT
        strftime('%Y-%m', o.order_date),
        ROUND(
            SUM(
                oi.quantity * oi.unit_price *
                (1 - oi.discount_percent / 100.0)
            ),
            2
        )
    FROM orders o
    JOIN order_items oi
        ON o.order_id = oi.order_id
    GROUP BY strftime('%Y-%m', o.order_date)
    ORDER BY strftime('%Y-%m', o.order_date);
    """

    rows = conn.execute(query).fetchall()

    lines = ["===== MONTHLY SALES ====="]

    if not rows:
        lines.append("No monthly sales data available.")

    for row in rows:
        lines.append(
            f"Month: {row[0]} | "
            f"Total Sales: ₹{row[1]:,.2f}"
        )

    content = "\n".join(lines) + "\n"

    print("\n" + content)
    save_report("monthly_sales.txt", content)

    conn.close()


# ============================================================
# REPORT 5: SALES BY REGION
# ============================================================

def show_sales_by_region():
    conn = get_connection()

    if conn is None:
        return

    query = """
    SELECT
        o.region_code,
        ROUND(
            SUM(
                oi.quantity * oi.unit_price *
                (1 - oi.discount_percent / 100.0)
            ),
            2
        )
    FROM orders o
    JOIN order_items oi
        ON o.order_id = oi.order_id
    GROUP BY o.region_code
    ORDER BY
        SUM(
            oi.quantity * oi.unit_price *
            (1 - oi.discount_percent / 100.0)
        ) DESC;
    """

    rows = conn.execute(query).fetchall()

    lines = ["===== SALES BY REGION ====="]

    if not rows:
        lines.append("No regional sales data available.")

    for row in rows:
        lines.append(
            f"Region: {row[0]} | "
            f"Total Sales: ₹{row[1]:,.2f}"
        )

    content = "\n".join(lines) + "\n"

    print("\n" + content)
    save_report("sales_by_region.txt", content)

    conn.close()


# ============================================================
# REPORT 6: ORDER STATUS ANALYSIS
# ============================================================

def show_order_status():
    conn = get_connection()

    if conn is None:
        return

    query = """
    SELECT
        status,
        COUNT(*) AS total_orders,
        ROUND(
            COUNT(*) * 100.0 /
            (SELECT COUNT(*) FROM orders),
            2
        ) AS percentage
    FROM orders
    GROUP BY status
    ORDER BY total_orders DESC;
    """

    rows = conn.execute(query).fetchall()

    lines = ["===== ORDER STATUS ANALYSIS ====="]

    if not rows:
        lines.append("No order status data available.")

    for row in rows:
        lines.append(
            f"Status: {row[0]} | "
            f"Orders: {row[1]} | "
            f"Percentage: {row[2]}%"
        )

    content = "\n".join(lines) + "\n"

    print("\n" + content)
    save_report("order_status.txt", content)

    conn.close()


# ============================================================
# REPORT 7: CUSTOMER TYPE ANALYSIS
# ============================================================

def show_customer_type():
    conn = get_connection()

    if conn is None:
        return

    query = """
    SELECT
        c.customer_type,
        COUNT(DISTINCT c.customer_id),
        COUNT(DISTINCT o.order_id),
        ROUND(
            SUM(
                oi.quantity * oi.unit_price *
                (1 - oi.discount_percent / 100.0)
            ),
            2
        )
    FROM customers c
    LEFT JOIN orders o
        ON c.customer_id = o.customer_id
    LEFT JOIN order_items oi
        ON o.order_id = oi.order_id
    GROUP BY c.customer_type
    ORDER BY
        SUM(
            oi.quantity * oi.unit_price *
            (1 - oi.discount_percent / 100.0)
        ) DESC;
    """

    rows = conn.execute(query).fetchall()

    lines = ["===== CUSTOMER TYPE ANALYSIS ====="]

    if not rows:
        lines.append("No customer type data available.")

    for row in rows:
        revenue = row[3] if row[3] is not None else 0

        lines.append(
            f"Type: {row[0]} | "
            f"Customers: {row[1]} | "
            f"Orders: {row[2]} | "
            f"Revenue: ₹{revenue:,.2f}"
        )

    content = "\n".join(lines) + "\n"

    print("\n" + content)
    save_report("customer_type.txt", content)

    conn.close()


# ============================================================
# REPORT 8: AVERAGE ORDER VALUE
# ============================================================

def show_average_order_value():
    conn = get_connection()

    if conn is None:
        return

    query = """
    SELECT
        COUNT(DISTINCT o.order_id),
        ROUND(
            SUM(
                oi.quantity * oi.unit_price *
                (1 - oi.discount_percent / 100.0)
            ),
            2
        ),
        ROUND(
            SUM(
                oi.quantity * oi.unit_price *
                (1 - oi.discount_percent / 100.0)
            ) / COUNT(DISTINCT o.order_id),
            2
        )
    FROM orders o
    JOIN order_items oi
        ON o.order_id = oi.order_id;
    """

    row = conn.execute(query).fetchone()

    total_orders = row[0] if row[0] is not None else 0
    total_revenue = row[1] if row[1] is not None else 0
    average_order_value = row[2] if row[2] is not None else 0

    content = (
        "===== AVERAGE ORDER VALUE =====\n"
        f"Total Orders: {total_orders}\n"
        f"Total Revenue: ₹{total_revenue:,.2f}\n"
        f"Average Order Value: ₹{average_order_value:,.2f}\n"
    )

    print("\n" + content)
    save_report("average_order_value.txt", content)

    conn.close()


# ============================================================
# REPORT 9: DATA QUALITY SUMMARY
# ============================================================

def show_data_quality():
    conn = get_connection()

    if conn is None:
        return

    total_orders = conn.execute("""
        SELECT COUNT(*)
        FROM orders;
    """).fetchone()[0]

    orders_without_items = conn.execute("""
        SELECT COUNT(*)
        FROM orders o
        LEFT JOIN order_items oi
            ON o.order_id = oi.order_id
        WHERE oi.order_id IS NULL;
    """).fetchone()[0]

    orders_without_customer = conn.execute("""
        SELECT COUNT(*)
        FROM orders
        WHERE customer_id IS NULL;
    """).fetchone()[0]

    invalid_customer_ids = conn.execute("""
        SELECT COUNT(*)
        FROM orders o
        LEFT JOIN customers c
            ON o.customer_id = c.customer_id
        WHERE o.customer_id IS NOT NULL
          AND c.customer_id IS NULL;
    """).fetchone()[0]

    content = (
        "===== DATA QUALITY SUMMARY =====\n"
        f"Total Orders: {total_orders}\n"
        f"Orders Without Items: {orders_without_items}\n"
        f"Orders Without Customer ID: {orders_without_customer}\n"
        f"Orders With Invalid Customer ID: {invalid_customer_ids}\n"
    )

    print("\n" + content)
    save_report("data_quality.txt", content)

    conn.close()


# ============================================================
# REPORT 10: MOST FREQUENT CUSTOMERS
# ============================================================

def show_frequent_customers():
    conn = get_connection()

    if conn is None:
        return

    query = """
    SELECT
        c.customer_id,
        c.customer_name,
        COUNT(DISTINCT o.order_id) AS total_orders,
        ROUND(
            SUM(
                oi.quantity * oi.unit_price *
                (1 - oi.discount_percent / 100.0)
            ),
            2
        ) AS total_spent
    FROM customers c
    JOIN orders o
        ON c.customer_id = o.customer_id
    JOIN order_items oi
        ON o.order_id = oi.order_id
    GROUP BY c.customer_id, c.customer_name
    ORDER BY total_orders DESC, total_spent DESC
    LIMIT 10;
    """

    rows = conn.execute(query).fetchall()

    lines = ["===== MOST FREQUENT CUSTOMERS ====="]

    if not rows:
        lines.append("No customer order data available.")

    for row in rows:
        lines.append(
            f"Customer ID: {row[0]} | "
            f"Name: {row[1]} | "
            f"Orders: {row[2]} | "
            f"Total Spent: ₹{row[3]:,.2f}"
        )

    content = "\n".join(lines) + "\n"

    print("\n" + content)
    save_report("frequent_customers.txt", content)

    conn.close()


# ============================================================
# REPORT 11: CUSTOMER RETENTION
# ============================================================

def show_retention():
    conn = get_connection()

    if conn is None:
        return

    query = """
    WITH CustomerFirstPurchase AS (
        SELECT
            customer_id,
            MIN(DATE(order_date, 'start of month')) AS cohort_month
        FROM orders
        WHERE customer_id IS NOT NULL
        GROUP BY customer_id
    ),

    CustomerActivity AS (
        SELECT DISTINCT
            customer_id,
            DATE(order_date, 'start of month') AS activity_month
        FROM orders
        WHERE customer_id IS NOT NULL
    ),

    CohortActivity AS (
        SELECT
            cfp.cohort_month,
            ca.activity_month,
            ca.customer_id
        FROM CustomerFirstPurchase cfp
        JOIN CustomerActivity ca
            ON cfp.customer_id = ca.customer_id
    ),

    CohortSize AS (
        SELECT
            cohort_month,
            COUNT(DISTINCT customer_id) AS cohort_customers
        FROM CohortActivity
        WHERE activity_month = cohort_month
        GROUP BY cohort_month
    )

    SELECT
        ca.cohort_month,
        ca.activity_month,
        COUNT(DISTINCT ca.customer_id) AS active_customers,
        cs.cohort_customers,
        ROUND(
            COUNT(DISTINCT ca.customer_id) * 100.0 /
            cs.cohort_customers,
            2
        ) AS retention_rate
    FROM CohortActivity ca
    JOIN CohortSize cs
        ON ca.cohort_month = cs.cohort_month
    GROUP BY
        ca.cohort_month,
        ca.activity_month,
        cs.cohort_customers
    ORDER BY
        ca.cohort_month,
        ca.activity_month;
    """

    rows = conn.execute(query).fetchall()

    lines = ["===== CUSTOMER RETENTION ANALYSIS ====="]

    if not rows:
        lines.append("No retention data available.")

    for row in rows:
        lines.append(
            f"Cohort: {row[0]} | "
            f"Activity Month: {row[1]} | "
            f"Active Customers: {row[2]} | "
            f"Cohort Size: {row[3]} | "
            f"Retention: {row[4]}%"
        )

    content = "\n".join(lines) + "\n"

    print("\n" + content)
    save_report("retention.txt", content)

    conn.close()


# ============================================================
# INTERACTIVE MENU
# ============================================================

def show_menu():
    print("\n" + "=" * 45)
    print("       E-COMMERCE ANALYTICS SYSTEM")
    print("=" * 45)

    print("1. Total Sales")
    print("2. Top 10 Products")
    print("3. Top 10 Customers")
    print("4. Monthly Sales")
    print("5. Sales by Region")
    print("6. Order Status Analysis")
    print("7. Customer Type Analysis")
    print("8. Average Order Value")
    print("9. Data Quality Summary")
    print("10. Most Frequent Customers")
    print("11. Customer Retention")
    print("0. Exit")


# ============================================================
# INTERACTIVE MODE
# ============================================================

def interactive_mode():

    create_report_directory()

    while True:

        show_menu()

        choice = input("\nEnter your choice: ").strip()

        if choice == "0":
            print("\nExiting Analytics System...")
            break

        elif choice == "1":
            show_total_sales()

        elif choice == "2":
            show_top_products()

        elif choice == "3":
            show_top_customers()

        elif choice == "4":
            show_monthly_sales()

        elif choice == "5":
            show_sales_by_region()

        elif choice == "6":
            show_order_status()

        elif choice == "7":
            show_customer_type()

        elif choice == "8":
            show_average_order_value()

        elif choice == "9":
            show_data_quality()

        elif choice == "10":
            show_frequent_customers()

        elif choice == "11":
            show_retention()

        else:
            print("\nInvalid choice. Please enter a number from 0 to 11.")


# ============================================================
# COMMAND-LINE ARGUMENT MODE
# ============================================================

REPORT_FUNCTIONS = {
    "revenue": show_total_sales,
    "total_sales": show_total_sales,
    "top_products": show_top_products,
    "top_customers": show_top_customers,
    "monthly_sales": show_monthly_sales,
    "sales_by_region": show_sales_by_region,
    "order_status": show_order_status,
    "customer_type": show_customer_type,
    "average_order_value": show_average_order_value,
    "data_quality": show_data_quality,
    "frequent_customers": show_frequent_customers,
    "retention": show_retention
}


def main():

    parser = argparse.ArgumentParser(
        description="E-Commerce Order Analytics Reporting Tool"
    )

    parser.add_argument(
        "--report",
        choices=REPORT_FUNCTIONS.keys(),
        help="Report to generate"
    )

    args = parser.parse_args()

    if args.report:
        REPORT_FUNCTIONS[args.report]()
    else:
        interactive_mode()


# ============================================================
# PROGRAM ENTRY POINT
# ============================================================

if __name__ == "__main__":
    main()
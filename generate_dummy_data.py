import os
import random
from datetime import datetime, timedelta
import pandas as pd
from faker import Faker

# Initialize Faker with Pakistan locale
fake = Faker('en_US') # Will manually use Pakistani names

# Setup directories
OUTPUT_DIR = "dummy_data"
if not os.path.exists(OUTPUT_DIR):
    os.makedirs(OUTPUT_DIR)

# Constants for counts - Adjusted down for Milestone 3 (min 50 rows per table)
NUM_CUSTOMERS = 60
NUM_EMPLOYEES = 50
NUM_SALES = 150

print(f"Generating data for Inventory Sales Management System in '{OUTPUT_DIR}' folder...")

# ==========================================
# 1. COMPANIES
# ==========================================
companies_data = [
    {"company_id": 1, "company_name": "PepsiCo Pakistan"},
    {"company_id": 2, "company_name": "Sufi Group"},
    {"company_id": 3, "company_name": "Mitchells Fruit Farms"},
    {"company_id": 4, "company_name": "Murree Brewery"},
    {"company_id": 5, "company_name": "Qarshi Industries"},
    {"company_id": 6, "company_name": "Hamdard Pakistan"}
]
df_companies = pd.DataFrame(companies_data)
df_companies.to_csv(f"{OUTPUT_DIR}/companies.csv", index=False)

# ==========================================
# 2. CATEGORIES
# ==========================================
category_names = [
    "Beverages", "Cooking Oil & Ghee", "Cleaning & Laundry", 
    "Jams & Preserves", "Squashes & Syrups", "Condiments & Sauces"
]
categories_data = [{"category_id": i+1, "category_name": name} for i, name in enumerate(category_names)]
df_categories = pd.DataFrame(categories_data)
df_categories.to_csv(f"{OUTPUT_DIR}/categories.csv", index=False)

def get_category_id(name):
    for c in categories_data:
        if c['category_name'] == name: return c['category_id']
    return 1

# ==========================================
# 3. PRODUCTS
# ==========================================
products_list = []
prod_id = 1

real_products = [
    (1, "Beverages", ["Pepsi", "Mountain Dew", "7UP", "Sting", "Mirinda"], ["500ml", "1L", "1.5L", "250ml Can"]),
    (1, "Beverages", ["Aquafina Bottled Water"], ["500ml", "1.5L", "5L"]),
    (2, "Cooking Oil & Ghee", ["Canola Oil", "Sunflower Oil"], ["1 Ltr Pouch", "3 Ltr Bottle", "5 Ltr Tin"]),
    (2, "Cooking Oil & Ghee", ["Banaspati Ghee"], ["1 Kg Pouch", "2.5 Kg Tin", "5 Kg Tin"]),
    (2, "Cleaning & Laundry", ["Laundry Soap", "Detergent Powder", "Safon Dishwasher"], ["Regular", "Large", "Economy Pack"]),
    (3, "Jams & Preserves", ["Strawberry Jam", "Apricot Jam", "Mango Jam", "Golden Apple Jam", "Diet Jam"], ["200g", "440g", "800g"]),
    (3, "Squashes & Syrups", ["Mango Squash", "Lemon Juice", "Fruit Squashes"], ["800ml", "1000ml"]),
    (3, "Condiments & Sauces", ["White Vinegar", "Garlic Paste", "Tomato Ketchup"], ["300ml", "500g", "800g Pouch"]),
    (4, "Beverages", ["Malt Drink Apple", "Malt Drink Lemon", "Malt Drink Peach", "Malt 79"], ["330ml Can", "500ml Bottle"]),
    (4, "Beverages", ["Tops Mango Juice", "Tops Apple Juice", "Tops Orange Juice"], ["250ml", "1 Ltr"]),
    (4, "Jams & Preserves", ["Mixed Fruit Jam"], ["200g", "440g"]),
    (5, "Squashes & Syrups", ["Jam-e-Shirin", "Sharbat-e-Ilaichi", "Sharbat-e-Sandal"], ["800ml", "1.5L"]),
    (6, "Squashes & Syrups", ["Rooh Afza"], ["400ml", "800ml", "1.5L"])
]

for comp_id, cat_name, items, sizes in real_products:
    cat_id = get_category_id(cat_name)
    for item in items:
        for size in sizes:
            purchase_price = round(random.uniform(100, 800), 2)
            selling_price = round(purchase_price * random.uniform(1.10, 1.30), 2)
            products_list.append({
                "product_id": prod_id,
                "product_name": f"{item} ({size})",
                "size_weight": size,
                "unit": "Piece" if "Pack" in size else ("Bottle" if "L" in size or "ml" in size else "Unit"),
                "stock_quantity": random.randint(50, 300),
                "purchase_price": purchase_price,
                "selling_price": selling_price,
                "low_stock_limit": random.randint(10, 30),
                "expiry_date": (datetime.now() + timedelta(days=random.randint(90, 730))).strftime("%Y-%m-%d"),
                "company_id": comp_id,
                "category_id": cat_id
            })
            prod_id += 1

df_products = pd.DataFrame(products_list)
df_products.to_csv(f"{OUTPUT_DIR}/products.csv", index=False)
NUM_PRODUCTS = len(products_list)

# ==========================================
# 4. CUSTOMERS
# ==========================================
pakistani_first_names = ["Ali", "Ahmad", "Muhammad", "Usman", "Umar", "Zain", "Hassan", "Hussain", "Bilal", "Tariq", "Fatima", "Ayesha", "Zainab", "Maryam", "Sana", "Rabia", "Khadija", "Hafsa", "Sadia", "Amna"]
pakistani_last_names = ["Khan", "Ahmed", "Ali", "Syed", "Shah", "Iqbal", "Malik", "Chaudhry", "Raza", "Sheikh", "Qureshi", "Ansari", "Mirza", "Baig", "Memon"]
shop_types = ["Mart", "Supermarket", "General Store", "Traders", "Karyana Store", "Mini Mart"]
areas = ["Clifton", "DHA", "Gulshan", "Nazimabad", "Saddar", "Tariq Road", "Johar", "Malir", "Korangi", "Lyari"]

customers_data = []
for i in range(1, NUM_CUSTOMERS + 1):
    first = random.choice(pakistani_first_names)
    last = random.choice(pakistani_last_names)
    customers_data.append({
        "customer_id": i,
        "shop_name": f"{first} {random.choice(shop_types)}",
        "phone": f"03{random.randint(0, 4)}{random.randint(1000000, 9999999)}",
        "area": random.choice(areas)
    })
df_customers = pd.DataFrame(customers_data)
df_customers.to_csv(f"{OUTPUT_DIR}/customers.csv", index=False)

# ==========================================
# 5. EMPLOYEES
# ==========================================
employees_data = []
roles = ["Sales Rep", "Store Manager", "Cashier", "Inventory Clerk"]
for i in range(1, NUM_EMPLOYEES + 1):
    first = random.choice(pakistani_first_names)
    last = random.choice(pakistani_last_names)
    employees_data.append({
        "employee_id": i,
        "name": f"{first} {last}",
        "phone": f"03{random.randint(0, 4)}{random.randint(1000000, 9999999)}",
        "salary": round(random.uniform(35000, 80000), 2),
        "job_role": random.choice(roles)
    })
df_employees = pd.DataFrame(employees_data)
df_employees.to_csv(f"{OUTPUT_DIR}/employees.csv", index=False)

# ==========================================
# 6. SALES & SALE_ITEMS
# ==========================================
sales_data = []
sale_items_data = []
sale_item_id = 1
start_date = datetime.now() - timedelta(days=180)

for sale_id in range(1, NUM_SALES + 1):
    sale_date = start_date + timedelta(days=random.randint(0, 180), hours=random.randint(8, 20))
    discount = round(random.uniform(0, 200), 2) if random.random() > 0.8 else 0.0
    
    sales_data.append({
        "sale_id": sale_id,
        "sale_date": sale_date.strftime("%Y-%m-%d"),
        "delivery_type": random.choice(["Pickup", "Delivery"]),
        "discount_amount": discount,
        "customer_id": random.randint(1, NUM_CUSTOMERS),
        "employee_id": random.randint(1, NUM_EMPLOYEES)
    })
    
    # Generate 1 to 5 items to keep it limited
    num_items = random.randint(1, 5)
    selected_products = random.sample(products_list, num_items)
    
    for prod in selected_products:
        qty = random.randint(1, 15)
        sale_items_data.append({
            "sale_item_id": sale_item_id,
            "quantity": qty,
            "unit_price": prod["selling_price"],
            "sale_id": sale_id,
            "product_id": prod["product_id"]
        })
        sale_item_id += 1

df_sales = pd.DataFrame(sales_data)
df_sales.to_csv(f"{OUTPUT_DIR}/sales.csv", index=False)

df_sale_items = pd.DataFrame(sale_items_data)
df_sale_items.to_csv(f"{OUTPUT_DIR}/sale_items.csv", index=False)

print(f"Total Rows:")
print(f" - companies.csv: {len(companies_data)}")
print(f" - categories.csv: {len(categories_data)}")
print(f" - products.csv: {NUM_PRODUCTS}")
print(f" - customers.csv: {NUM_CUSTOMERS}")
print(f" - employees.csv: {NUM_EMPLOYEES}")
print(f" - sales.csv: {NUM_SALES}")
print(f" - sale_items.csv: {len(sale_items_data)}")

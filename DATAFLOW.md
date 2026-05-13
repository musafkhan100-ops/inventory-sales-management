# Milestone 3 — Dataset Preprocessing & Dataflow

## Dataflow Description

**Project:** Inventory & Sales Management System  
**Authors:** Mushaf Mashood & Eshaal Nazir

### 1. Where Data Enters the System
Data enters our system through two primary channels:
- **Administrative/Managerial Input:** Store managers or admins manually input master data into the system. This includes registering new supplier `COMPANIES`, defining product `CATEGORIES`, adding new `PRODUCTS` to the inventory (including setting purchase/selling prices and low stock limits), and registering new `EMPLOYEES`.
- **Transactional Input:** Data enters continuously during daily operations when `CUSTOMERS` place orders at the shop. The `EMPLOYEES` (cashiers/sales reps) process these transactions at the point of sale.

### 2. How Data Moves Through the Database
The movement of data relies heavily on the relationships defined in our normalized schema:
- **Master Data Dependency:** Before any sale can occur, the `PRODUCTS` table must be populated. The `PRODUCTS` table itself depends on the `COMPANIES` and `CATEGORIES` tables being populated first (via foreign keys `company_id` and `category_id`).
- **Transaction Flow:** When a customer makes a purchase, their information is first verified or added to the `CUSTOMERS` table. A new record is then generated in the `SALES` table, capturing the `sale_date`, `delivery_type`, and any `discount_amount`. This `SALES` record links directly to the `customer_id` and the `employee_id` processing the order.
- **Line Item Resolution:** For every individual product in that sale, a record is created in the `SALE_ITEMS` table. This table acts as the critical junction, linking the `sale_id` to the specific `product_id`, and recording the `quantity` and historical `unit_price` at the time of sale. As `SALE_ITEMS` are recorded, the `stock_quantity` in the `PRODUCTS` table would be dynamically reduced in a real-world application.

### 3. What Comes Out of the System
The structured data flowing into the database is extracted and transformed into actionable insights and reports:
- **Inventory Alerts & Reports:** By querying the `PRODUCTS` table where `stock_quantity <= low_stock_limit`, the system outputs automated low-stock alerts so managers can reorder from suppliers (`COMPANIES`).
- **Financial & Sales Reports:** Querying `SALES` and `SALE_ITEMS` generates daily/monthly revenue reports, profit margin analysis (comparing `unit_price` in `SALE_ITEMS` against `purchase_price` in `PRODUCTS`), and identifies top-selling product categories.
- **Performance & CRM Output:** Data is output as employee performance reports (number of sales handled per `employee_id`) and customer purchase history reports for targeted promotions or loyalty programs.

---

## Dataset Generation Details

As per Milestone 3 requirements, synthetic data was generated using a custom Python script leveraging the `Faker` and `pandas` libraries. The dataset focuses on major Pakistani FMCG brands (PepsiCo Pakistan, Sufi Group, Mitchells Fruit Farms, Murree Brewery, Qarshi Industries, Hamdard Pakistan).

**Generated File Counts (located in `dummy_data/` folder):**
- `companies.csv`: 6 records
- `categories.csv`: 6 records
- `products.csv`: 96 records
- `customers.csv`: 60 records
- `employees.csv`: 50 records
- `sales.csv` (Orders): 150 records
- `sale_items.csv` (Order Items): 458 records

All files adhere strictly to the 3NF schema finalized in Milestone 2. No derived columns (like `subtotal` or `total_amount`) are included.

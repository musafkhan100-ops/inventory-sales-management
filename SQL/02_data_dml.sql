-- ==============================================================================
-- Milestone 5: DML Script (Data Population)
-- ==============================================================================
USE inventory_sales_management;

-- Note: In MySQL, you often need to use forward slashes (/) for paths or escape backslashes (\\).
-- Also, if you encounter a --secure-file-priv error, you may need to copy your CSVs 
-- to the secure folder allowed by MySQL (e.g., C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/)
-- and update the paths below accordingly.

-- 1. COMPANIES
LOAD DATA INFILE 'c:/Users/musaf.DESKTOP-LMC1EGF/Desktop/database project/inventory-sales-management/dummy_data/companies.csv'
INTO TABLE COMPANIES
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(company_id, company_name);

-- 2. CATEGORIES
LOAD DATA INFILE 'c:/Users/musaf.DESKTOP-LMC1EGF/Desktop/database project/inventory-sales-management/dummy_data/categories.csv'
INTO TABLE CATEGORIES
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(category_id, category_name);

-- 3. PRODUCTS
LOAD DATA INFILE 'c:/Users/musaf.DESKTOP-LMC1EGF/Desktop/database project/inventory-sales-management/dummy_data/products.csv'
INTO TABLE PRODUCTS
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(product_id, product_name, size_weight, unit, stock_quantity, purchase_price, selling_price, low_stock_limit, expiry_date, company_id, category_id)
SET expiry_date = NULLIF(expiry_date, '');

-- 4. CUSTOMERS
LOAD DATA INFILE 'c:/Users/musaf.DESKTOP-LMC1EGF/Desktop/database project/inventory-sales-management/dummy_data/customers.csv'
INTO TABLE CUSTOMERS
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(customer_id, shop_name, phone, area);

-- 5. EMPLOYEES
LOAD DATA INFILE 'c:/Users/musaf.DESKTOP-LMC1EGF/Desktop/database project/inventory-sales-management/dummy_data/employees.csv'
INTO TABLE EMPLOYEES
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(employee_id, name, phone, salary, job_role);

-- 6. SALES
LOAD DATA INFILE 'c:/Users/musaf.DESKTOP-LMC1EGF/Desktop/database project/inventory-sales-management/dummy_data/sales.csv'
INTO TABLE SALES
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(sale_id, sale_date, delivery_type, discount_amount, customer_id, employee_id);

-- 7. SALE_ITEMS
LOAD DATA INFILE 'c:/Users/musaf.DESKTOP-LMC1EGF/Desktop/database project/inventory-sales-management/dummy_data/sale_items.csv'
INTO TABLE SALE_ITEMS
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(sale_item_id, quantity, unit_price, sale_id, product_id);


-- ==============================================================================
-- UPDATE AND DELETE DEMONSTRATION
-- ==============================================================================

-- 1 UPDATE operation with a WHERE condition
-- Increase the selling price by 10% for products belonging to a specific category (e.g. category 1)
UPDATE PRODUCTS
SET selling_price = selling_price * 1.10
WHERE category_id = 1;

-- 1 DELETE operation with a WHERE condition
-- Remove any dummy customer that might have an empty area (assuming none, but demonstrating the syntax)
DELETE FROM CUSTOMERS
WHERE area = '';

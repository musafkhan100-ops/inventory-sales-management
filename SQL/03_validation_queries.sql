-- ==============================================================================
-- Milestone 5: Validation Queries
-- ==============================================================================
USE inventory_sales_management;

-- 1. COUNT (*) for each table to confirm row counts
SELECT 'COMPANIES' AS TableName, COUNT(*) AS RowCount FROM COMPANIES
UNION ALL
SELECT 'CATEGORIES', COUNT(*) FROM CATEGORIES
UNION ALL
SELECT 'PRODUCTS', COUNT(*) FROM PRODUCTS
UNION ALL
SELECT 'CUSTOMERS', COUNT(*) FROM CUSTOMERS
UNION ALL
SELECT 'EMPLOYEES', COUNT(*) FROM EMPLOYEES
UNION ALL
SELECT 'SALES', COUNT(*) FROM SALES
UNION ALL
SELECT 'SALE_ITEMS', COUNT(*) FROM SALE_ITEMS;


-- 2. NULL check on key columns
-- These queries should return 0 if there are no NULLs in the primary keys
SELECT 
    (SELECT COUNT(*) FROM COMPANIES WHERE company_id IS NULL) AS Companies_Null_PK,
    (SELECT COUNT(*) FROM CATEGORIES WHERE category_id IS NULL) AS Categories_Null_PK,
    (SELECT COUNT(*) FROM PRODUCTS WHERE product_id IS NULL) AS Products_Null_PK,
    (SELECT COUNT(*) FROM CUSTOMERS WHERE customer_id IS NULL) AS Customers_Null_PK,
    (SELECT COUNT(*) FROM EMPLOYEES WHERE employee_id IS NULL) AS Employees_Null_PK,
    (SELECT COUNT(*) FROM SALES WHERE sale_id IS NULL) AS Sales_Null_PK,
    (SELECT COUNT(*) FROM SALE_ITEMS WHERE sale_item_id IS NULL) AS Sale_Items_Null_PK;


-- 3. JOIN-based check to confirm foreign key integrity is intact
-- This checks if every SALE_ITEM has a valid reference to a SALE and a valid reference to a PRODUCT.
-- If the count matches the total number of SALE_ITEMS, FK integrity is verified.
SELECT 
    (SELECT COUNT(*) FROM SALE_ITEMS) AS Total_Sale_Items,
    (SELECT COUNT(*) 
     FROM SALE_ITEMS si
     JOIN SALES s ON si.sale_id = s.sale_id
     JOIN PRODUCTS p ON si.product_id = p.product_id) AS Valid_Sale_Items_With_FKs;

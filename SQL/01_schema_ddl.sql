-- Database creation
CREATE DATABASE IF NOT EXISTS inventory_sales_management;
USE inventory_sales_management;

-- COMPANIES Table
CREATE TABLE COMPANIES (
    company_id INT AUTO_INCREMENT PRIMARY KEY,
    company_name VARCHAR(255) NOT NULL UNIQUE
);

-- CATEGORIES Table
CREATE TABLE CATEGORIES (
    category_id INT AUTO_INCREMENT PRIMARY KEY,
    category_name VARCHAR(255) NOT NULL UNIQUE
);

-- PRODUCTS Table
CREATE TABLE PRODUCTS (
    product_id INT AUTO_INCREMENT PRIMARY KEY,
    product_name VARCHAR(255) NOT NULL,
    size_weight VARCHAR(100),
    unit VARCHAR(50) NOT NULL,
    stock_quantity INT NOT NULL CHECK (stock_quantity >= 0),
    purchase_price DECIMAL(10, 2) NOT NULL CHECK (purchase_price >= 0),
    selling_price DECIMAL(10, 2) NOT NULL CHECK (selling_price >= 0),
    low_stock_limit INT NOT NULL CHECK (low_stock_limit >= 0),
    expiry_date DATE,
    company_id INT NOT NULL,
    category_id INT NOT NULL,
    FOREIGN KEY (company_id) REFERENCES COMPANIES(company_id) ON DELETE RESTRICT ON UPDATE CASCADE,
    FOREIGN KEY (category_id) REFERENCES CATEGORIES(category_id) ON DELETE RESTRICT ON UPDATE CASCADE
);

-- Indexes for PRODUCTS
CREATE INDEX idx_products_company ON PRODUCTS(company_id);
CREATE INDEX idx_products_category ON PRODUCTS(category_id);
CREATE INDEX idx_products_name ON PRODUCTS(product_name);

-- CUSTOMERS Table
CREATE TABLE CUSTOMERS (
    customer_id INT AUTO_INCREMENT PRIMARY KEY,
    shop_name VARCHAR(255) NOT NULL,
    phone VARCHAR(20) NOT NULL UNIQUE,
    area VARCHAR(255) NOT NULL
);

-- EMPLOYEES Table
CREATE TABLE EMPLOYEES (
    employee_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    phone VARCHAR(20) NOT NULL UNIQUE,
    salary DECIMAL(10, 2) NOT NULL CHECK (salary >= 0),
    job_role VARCHAR(100) NOT NULL
);

-- SALES Table
CREATE TABLE SALES (
    sale_id INT AUTO_INCREMENT PRIMARY KEY,
    sale_date DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    delivery_type VARCHAR(50) NOT NULL CHECK (delivery_type IN ('Pickup', 'Delivery')),
    discount_amount DECIMAL(10, 2) NOT NULL DEFAULT 0.00 CHECK (discount_amount >= 0),
    customer_id INT NOT NULL,
    employee_id INT NOT NULL,
    FOREIGN KEY (customer_id) REFERENCES CUSTOMERS(customer_id) ON DELETE RESTRICT ON UPDATE CASCADE,
    FOREIGN KEY (employee_id) REFERENCES EMPLOYEES(employee_id) ON DELETE RESTRICT ON UPDATE CASCADE
);

-- Indexes for SALES
CREATE INDEX idx_sales_customer ON SALES(customer_id);
CREATE INDEX idx_sales_employee ON SALES(employee_id);
CREATE INDEX idx_sales_date ON SALES(sale_date);

-- SALE_ITEMS Table
CREATE TABLE SALE_ITEMS (
    sale_item_id INT AUTO_INCREMENT PRIMARY KEY,
    quantity INT NOT NULL CHECK (quantity > 0),
    unit_price DECIMAL(10, 2) NOT NULL CHECK (unit_price >= 0),
    sale_id INT NOT NULL,
    product_id INT NOT NULL,
    FOREIGN KEY (sale_id) REFERENCES SALES(sale_id) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (product_id) REFERENCES PRODUCTS(product_id) ON DELETE RESTRICT ON UPDATE CASCADE
);

-- Indexes for SALE_ITEMS
CREATE INDEX idx_sale_items_sale ON SALE_ITEMS(sale_id);
CREATE INDEX idx_sale_items_product ON SALE_ITEMS(product_id);

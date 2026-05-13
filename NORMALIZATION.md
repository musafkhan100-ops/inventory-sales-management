# Normalization Document — Milestone 2

## Inventory & Sales Management System
**Authors:** Mushaf Mashood & Eshaal Nazir  
**Date:** May 2025

---

## 1. Original Schema (from Milestone 1)

| Table | Attributes |
|-------|-----------|
| COMPANIES | company_id (PK), company_name |
| CATEGORIES | category_id (PK), category_name |
| PRODUCTS | product_id (PK), product_name, size_weight, unit, stock_quantity, purchase_price, selling_price, low_stock_limit, expiry_date, company_id (FK), category_id (FK) |
| CUSTOMERS | customer_id (PK), shop_name, phone, area |
| EMPLOYEES | employee_id (PK), name, phone, salary, job_role |
| SALES | sale_id (PK), sale_date, delivery_type, discount_amount, ~~total_amount~~, customer_id (FK), employee_id (FK) |
| SALE_ITEMS | sale_item_id (PK), quantity, unit_price, ~~subtotal~~, sale_id (FK), product_id (FK) |

---

## 2. First Normal Form (1NF) Analysis

**Rule:** All columns must contain atomic values, each row must be unique (via PK), and no repeating groups.

| Table | Analysis | Status |
|-------|----------|--------|
| COMPANIES | Single atomic attribute (company_name). Unique PK (company_id). No repeating groups. | ✅ Already in 1NF |
| CATEGORIES | Single atomic attribute (category_name). Unique PK (category_id). No repeating groups. | ✅ Already in 1NF |
| PRODUCTS | All attributes store single atomic values. Product items are not repeated — line items are stored separately in SALE_ITEMS. | ✅ Already in 1NF |
| CUSTOMERS | shop_name, phone, area are all atomic. One phone per customer. | ✅ Already in 1NF |
| EMPLOYEES | name, phone, salary, job_role are all atomic single values. | ✅ Already in 1NF |
| SALES | All attributes are atomic. Products sold are stored in SALE_ITEMS (no repeating groups here). | ✅ Already in 1NF |
| SALE_ITEMS | All attributes are atomic. Each row represents one product in one sale. | ✅ Already in 1NF |

**Conclusion:** All tables satisfy 1NF. The separation of line items into SALE_ITEMS was a key design decision that prevents repeating groups.

---

## 3. Second Normal Form (2NF) Analysis

**Rule:** Must be in 1NF + no partial dependencies (non-key attributes must depend on the *entire* primary key).

**Key Observation:** All seven tables use **single-column primary keys** (auto-increment integers). Partial dependencies can only occur with composite keys. Therefore, 2NF is automatically satisfied.

| Table | PK Type | Analysis | Status |
|-------|---------|----------|--------|
| COMPANIES | Single (company_id) | No composite PK → no partial dependency possible | ✅ Already in 2NF |
| CATEGORIES | Single (category_id) | No composite PK → no partial dependency possible | ✅ Already in 2NF |
| PRODUCTS | Single (product_id) | All attributes fully depend on product_id | ✅ Already in 2NF |
| CUSTOMERS | Single (customer_id) | All attributes fully depend on customer_id | ✅ Already in 2NF |
| EMPLOYEES | Single (employee_id) | All attributes fully depend on employee_id | ✅ Already in 2NF |
| SALES | Single (sale_id) | All attributes fully depend on sale_id | ✅ Already in 2NF |
| SALE_ITEMS | Single (sale_item_id) | All attributes fully depend on sale_item_id. If composite PK (sale_id, product_id) had been used, unit_price could partially depend on product_id — avoided by using surrogate PK. | ✅ Already in 2NF |

**Conclusion:** All tables satisfy 2NF due to single-column surrogate primary keys.

---

## 4. Third Normal Form (3NF) Analysis

**Rule:** Must be in 2NF + no transitive dependencies (non-key attributes must not depend on other non-key attributes).

| Table | Analysis | Status |
|-------|----------|--------|
| COMPANIES | Only one non-key attribute (company_name) — transitive dependency is impossible. | ✅ Already in 3NF |
| CATEGORIES | Only one non-key attribute (category_name) — transitive dependency is impossible. | ✅ Already in 3NF |
| PRODUCTS | All attributes are independent facts about the product. selling_price and purchase_price are independently set, not derived from each other. | ✅ Already in 3NF |
| CUSTOMERS | shop_name, phone, area all depend directly on customer_id. area is an attribute of the customer, not derived. | ✅ Already in 3NF |
| EMPLOYEES | All attributes depend directly on employee_id. salary is per-employee (not determined by job_role). | ✅ Already in 3NF |
| **SALES** | **⚠️ VIOLATION:** `total_amount` is a **derived column** — it can be computed as `SUM(sale_items.quantity * sale_items.unit_price) - discount_amount`. It transitively depends on SALE_ITEMS data. | ❌ **Fixed: Removed total_amount** |
| **SALE_ITEMS** | **⚠️ VIOLATION:** `subtotal` is a **derived column** — it equals `quantity × unit_price`. It depends on two other non-key attributes, not directly on sale_item_id. | ❌ **Fixed: Removed subtotal** |

### Changes Made:
1. **SALES:** Removed `total_amount` — can be computed via SQL query
2. **SALE_ITEMS:** Removed `subtotal` — can be computed as `quantity * unit_price`

---

## 5. Duplicate & Redundancy Check

| Item | Analysis | Action |
|------|----------|--------|
| Derived columns (subtotal, total_amount) | Stored values computable from existing data. Risk of inconsistency. | Removed (3NF fix) |
| Phone columns (CUSTOMERS vs EMPLOYEES) | Same attribute type for different entities — not true duplication | No change |
| Price columns (PRODUCTS prices vs SALE_ITEMS.unit_price) | PRODUCTS = current catalog price; SALE_ITEMS = historical price at sale time. Different purposes. | No change |
| Foreign keys | All FKs properly placed, no duplicates | No change |

---

## 6. Final Normalized Schema

### COMPANIES *(unchanged)*
`company_id (PK), company_name`

### CATEGORIES *(unchanged)*
`category_id (PK), category_name`

### PRODUCTS *(unchanged)*
`product_id (PK), product_name, size_weight, unit, stock_quantity, purchase_price, selling_price, low_stock_limit, expiry_date, company_id (FK), category_id (FK)`

### CUSTOMERS *(unchanged)*
`customer_id (PK), shop_name, phone, area`

### EMPLOYEES *(unchanged)*
`employee_id (PK), name, phone, salary, job_role`

### SALES *(updated — removed total_amount)*
`sale_id (PK), sale_date, delivery_type, discount_amount, customer_id (FK), employee_id (FK)`

### SALE_ITEMS *(updated — removed subtotal)*
`sale_item_id (PK), quantity, unit_price, sale_id (FK), product_id (FK)`

---

## 7. Updated ERD

The updated ERD reflecting all normalization changes is available in:
- `ERD/erd_milestone2.png`
- Embedded in `MILESTONES/milestone2.docx`

**Key visual changes:** `subtotal` removed from SALE_ITEMS entity, `total_amount` removed from SALES entity. All relationships and cardinalities remain unchanged.

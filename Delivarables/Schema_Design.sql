
-- Drop tables for safe re-run
DROP TABLE IF EXISTS orders;
DROP TABLE IF EXISTS inventory_snapshots;
DROP TABLE IF EXISTS warehouses;
DROP TABLE IF EXISTS suppliers;
DROP TABLE IF EXISTS products;

-- Tables
CREATE TABLE products (
    ProductID INT PRIMARY KEY,
    ProductName TEXT,
    Category TEXT
);

CREATE TABLE suppliers (
    SupplierID INT PRIMARY KEY,
    SupplierName TEXT,
    Region TEXT,
    AvgLeadTimeDays INT
);

CREATE TABLE warehouses (
    WarehouseID INT PRIMARY KEY,
    WarehouseName TEXT
);

CREATE TABLE inventory_snapshots (
    ProductID INT,
    SupplierID INT,
    WarehouseID INT,
    SnapshotDate DATE,
    StockLevel INT,
    ReorderPoint INT
);

CREATE TABLE orders (
    OrderID INT PRIMARY KEY,
    ProductID INT,
    SupplierID INT,
    WarehouseID INT,
    Quantity INT,
    OrderDate DATE,
    PlannedDeliveryDate DATE,
    ActualDeliveryDate DATE
);

-- Insert sample subset products
INSERT INTO products (ProductID, ProductName, Category) VALUES
(1, 'Laptop', 'Electronics'),
(2, 'Smartphone', 'Electronics'),
(3, 'T-Shirt', 'Clothing');

-- Insert sample subset suppliers
INSERT INTO suppliers (SupplierID, SupplierName, Region, AvgLeadTimeDays) VALUES
(1, 'AlphaSupplies', 'North', 10),
(2, 'BetaTraders', 'South', 14);

-- Insert warehouses (all)
INSERT INTO warehouses (WarehouseID, WarehouseName) VALUES
(1, 'WH_North'),
(2, 'WH_South'),
(3, 'WH_East');

-- Insert sample subset inventory snapshots
INSERT INTO inventory_snapshots (ProductID, SupplierID, WarehouseID, SnapshotDate, StockLevel, ReorderPoint) VALUES
(1, 1, 1, '2024-01-31', 50, 100),
(2, 2, 1, '2024-01-31', 120, 80),
(3, 1, 2, '2024-02-28', 30, 50),
(1, 2, 2, '2024-02-28', 70, 60),
(2, 1, 3, '2024-03-31', 20, 40),
(3, 2, 3, '2024-03-31', 90, 70);

-- Insert sample subset orders
INSERT INTO orders (OrderID, ProductID, SupplierID, WarehouseID, Quantity, OrderDate, PlannedDeliveryDate, ActualDeliveryDate) VALUES
(1, 1, 1, 1, 100, '2024-01-01', '2024-01-15', '2024-01-16'),
(2, 2, 2, 1, 200, '2024-01-10', '2024-01-25', '2024-01-24'),
(3, 3, 1, 2, 150, '2024-02-05', '2024-02-20', '2024-02-19'),
(4, 1, 2, 2, 300, '2024-02-15', '2024-03-01', '2024-03-05'), -- late
(5, 2, 1, 3, 80, '2024-03-10', '2024-03-25', '2024-03-27'); -- late

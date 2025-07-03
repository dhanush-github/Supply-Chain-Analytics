
-- ===============================================
-- 📊 2_business_queries.sql
-- Supply Chain Inventory Optimization
-- Analysis Queries Only
-- ===============================================

-- 1. Complex Join: Orders + Suppliers + Warehouses + Products
SELECT o.OrderID, o.ProductID, p.ProductName, s.SupplierName, w.WarehouseName, o.Quantity,
       o.OrderDate, o.PlannedDeliveryDate, o.ActualDeliveryDate
FROM orders o
JOIN products p ON o.ProductID = p.ProductID
JOIN suppliers s ON o.SupplierID = s.SupplierID
JOIN warehouses w ON o.WarehouseID = w.WarehouseID;

-- 2. CASE WHEN: Late Flag
SELECT OrderID, SupplierID,
       CASE WHEN ActualDeliveryDate > PlannedDeliveryDate THEN 'Late' ELSE 'On-Time' END AS DeliveryStatus
FROM orders;

-- 3. CTE: Stock Risk Reorder Suggestion
WITH stock_risk AS (
    SELECT ProductID, WarehouseID, AVG(StockLevel) AS AvgStock, AVG(ReorderPoint) AS AvgReorder
    FROM inventory_snapshots
    GROUP BY ProductID, WarehouseID
)
SELECT ProductID, WarehouseID, AvgStock, AvgReorder,
       CASE WHEN AvgStock < AvgReorder THEN 'Reorder Needed' ELSE 'Stock OK' END AS ReorderFlag
FROM stock_risk;

-- 4. Window Function: Supplier Rank by Late Deliveries
SELECT SupplierID, COUNT(*) AS LateDeliveries,
       RANK() OVER (ORDER BY COUNT(*) DESC) AS RankByLate
FROM orders
WHERE ActualDeliveryDate > PlannedDeliveryDate
GROUP BY SupplierID;

-- 5. Nested Query: Stockouts for High Lead Time Suppliers
SELECT ProductID, AVG(StockLevel) AS AvgStock
FROM inventory_snapshots
WHERE SupplierID IN (
    SELECT SupplierID FROM suppliers WHERE AvgLeadTimeDays > 10
)
GROUP BY ProductID
HAVING AVG(StockLevel) < 50;

-- 6. Rolling 3-Month Average Stock by Product
SELECT ProductID, SnapshotDate, StockLevel,
       AVG(StockLevel) OVER (
         PARTITION BY ProductID
         ORDER BY SnapshotDate
         ROWS BETWEEN 2 PRECEDING AND CURRENT ROW
       ) AS Rolling3MStock
FROM inventory_snapshots;

-- 7. HAVING: Suppliers with More Than 10 Late Deliveries
SELECT SupplierID, COUNT(*) AS LateDeliveries
FROM orders
WHERE ActualDeliveryDate > PlannedDeliveryDate
GROUP BY SupplierID
HAVING COUNT(*) > 10;

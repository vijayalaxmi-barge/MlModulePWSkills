-- ============================================================
-- SQL ASSIGNMENT – COPILOT WITH SQL
-- Questions 1–3
-- Database: Microsoft SQL Server / SSMS
-- ============================================================

-- ============================================================
-- QUESTION 1
-- Create SalesData table and insert 10,000 random rows
-- ============================================================

IF OBJECT_ID('dbo.SalesData', 'U') IS NOT NULL
    DROP TABLE dbo.SalesData;
GO

CREATE TABLE dbo.SalesData
(
    CustomerID INT PRIMARY KEY,
    Name VARCHAR(50),
    Age INT,
    City VARCHAR(50),
    PurchaseAmount DECIMAL(10,2),
    PurchaseDate DATE
);
GO

;WITH Numbers AS
(
    SELECT TOP (10000)
        ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) AS n
    FROM sys.all_objects a
    CROSS JOIN sys.all_objects b
)
INSERT INTO dbo.SalesData
(
    CustomerID,
    Name,
    Age,
    City,
    PurchaseAmount,
    PurchaseDate
)
SELECT
    n AS CustomerID,

    CASE ABS(CHECKSUM(NEWID())) % 6
        WHEN 0 THEN 'Amit'
        WHEN 1 THEN 'Riya'
        WHEN 2 THEN 'Rahul'
        WHEN 3 THEN 'Sneha'
        WHEN 4 THEN 'Priya'
        ELSE 'Karan'
    END AS Name,

    18 + ABS(CHECKSUM(NEWID())) % 48 AS Age,

    CASE ABS(CHECKSUM(NEWID())) % 6
        WHEN 0 THEN 'Mumbai'
        WHEN 1 THEN 'Pune'
        WHEN 2 THEN 'Delhi'
        WHEN 3 THEN 'Bangalore'
        WHEN 4 THEN 'Hyderabad'
        ELSE 'Chennai'
    END AS City,

    CAST(100 + ABS(CHECKSUM(NEWID())) % 4901 AS DECIMAL(10,2))
        AS PurchaseAmount,

    DATEADD(
        DAY,
        -ABS(CHECKSUM(NEWID())) % 1095,
        CAST(GETDATE() AS DATE)
    ) AS PurchaseDate

FROM Numbers;
GO

-- Verify that 10,000 rows were inserted
SELECT COUNT(*) AS TotalRows
FROM dbo.SalesData;
GO


-- ============================================================
-- QUESTION 2A
-- Find total sales per city
-- ============================================================

SELECT
    City,
    SUM(PurchaseAmount) AS TotalSales
FROM dbo.SalesData
GROUP BY City
ORDER BY TotalSales DESC;
GO


-- ============================================================
-- QUESTION 2B
-- Find the top 5 cities by revenue
-- ============================================================

SELECT TOP 5
    City,
    SUM(PurchaseAmount) AS TotalRevenue
FROM dbo.SalesData
GROUP BY City
ORDER BY TotalRevenue DESC;
GO


-- ============================================================
-- QUESTION 3
-- Find customers with purchases above average
-- ============================================================

SELECT
    CustomerID,
    Name,
    Age,
    City,
    PurchaseAmount,
    PurchaseDate
FROM dbo.SalesData
WHERE PurchaseAmount >
(
    SELECT AVG(PurchaseAmount)
    FROM dbo.SalesData
)
ORDER BY PurchaseAmount DESC;
GO


-- ============================================================
-- OPTIONAL VERIFICATION QUERIES
-- ============================================================

-- Display sample records
SELECT TOP 20 *
FROM dbo.SalesData
ORDER BY CustomerID;
GO

-- Check minimum, maximum and average purchase amount
SELECT
    MIN(PurchaseAmount) AS MinimumPurchase,
    MAX(PurchaseAmount) AS MaximumPurchase,
    AVG(PurchaseAmount) AS AveragePurchase
FROM dbo.SalesData;
GO

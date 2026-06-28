USE CEI_WEEK2;

--Task 1 - Exploring the Dataset

SELECT TOP 5 * 
FROM SUPERSTORE;

-- Count of rows

SELECT COUNT(*) AS TotalRows
FROM SUPERSTORE;

-- Distinct categories


-- displaying distinct regions

SELECT DISTINCT Region
FROM SUPERSTORE;
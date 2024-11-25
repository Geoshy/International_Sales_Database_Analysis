/*
Extract data on products and their suppliers (products with suppliers only).
*/

USE InternationalCompanySalesData;
GO 

SELECT *
FROM 
    Product AS P INNER JOIN Supplier AS S
    ON P.SupplierId = S.Id;
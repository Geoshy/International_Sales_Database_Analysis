/*
Extract Full Join Data from tables (Customer - Order - Product - Supplier) into one table to analyze it using Python.
*/

USE InternationalCompanySalesData;
GO

SELECT 
    C.*, O.*, P.*, S.*
FROM
    Customer AS C
    FULL JOIN [Order] AS O ON C.Id = O.CustomerId
    FULL JOIN OrderItem AS OI ON O.Id = OI.OrderId
    FULL JOIN Product AS P ON OI.ProductId = P.Id
    FULL JOIN Supplier AS S ON P.SupplierId = S.Id;
-- 2161
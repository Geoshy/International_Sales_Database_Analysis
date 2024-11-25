/*
Extracting Order Data with the Customer and Products for the Year 2013.

2013 (As it is the Only Year that has Completed Data)
*/

USE InternationalCompanySalesData;
GO

SELECT *
FROM 
    [Order] AS O INNER JOIN Customer AS C
    ON O.CustomerId = C.Id INNER JOIN OrderItem AS OI
    ON O.Id = OI.OrderId INNER JOIN Product AS P
    ON OI.ProductId = P.Id
WHERE
    O.OrderDate BETWEEN '2013-01-01 00:00:00' AND '2013-12-31 23:59:59';


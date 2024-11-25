/*
- Creating a view to save the query (Extracting Order Data with the Customer and Products for the Year 2013) 
and its result in the database catalog through a view object, 
as Views is a virtual table that does not have a physical existence on the hard, 
physically views data base object doesn't store data in the hard, but the data will be retrieved to it when calling it. 

- Make sure that column names in the view must be unique. 
Column name 'Id' in view 'OrderCP2013' is specified more than once, 
Make sure that all columns is unique in statement.

- I made this view using (create view in SQL Server) on the database.

- Note That Views are Always Up to Date.
*/

USE InternationalCompanySalesData;
GO

CREATE VIEW OrderCP2013 AS
SELECT O.Id, O.OrderDate, O.OrderNumber, O.CustomerId, O.TotalAmount, C.Id AS Expr1, C.FirstName, C.LastName, C.City, C.Country, C.Phone, P.Id AS Expr2, P.ProductName, P.SupplierId, P.UnitPrice, P.Package, P.IsDiscontinued
FROM   dbo.[Order] AS O INNER JOIN
             dbo.Customer AS C ON O.CustomerId = C.Id INNER JOIN
             dbo.OrderItem AS OI ON O.Id = OI.OrderId INNER JOIN
             dbo.Product AS P ON OI.ProductId = P.Id
WHERE (O.OrderDate BETWEEN '2013-01-01 00:00:00' AND '2013-12-31 23:59:59')
SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SP_GetLayawayItem](@Filter nvarchar(4000))
AS

DECLARE @MySelect nvarchar(2000)
SET @MySelect = 'SELECT (CASE WHEN [Transaction].TransactionType= 14 THEN ''Open'' WHEN [Transaction].TransactionType= 15 THEN ''Void'' WHEN [Transaction].TransactionType= 16 THEN ''Closed'' END) AS Status, 
                   DATEADD(day,Cast((select OptionValue from SetUpValues where OptionID = 871 and StoreID = ItemsQuery.StoreNo) As Int), [Transaction].StartSaleTime) AS ExpDate, Customer.CustomerNo, ISNULL(Customer.LastName, '''') + '' '' + ISNULL(Customer.FirstName, '''') AS CustomerName, ItemsQuery.Name As ItemName, 
                       ItemsQuery.BarcodeNumber AS Barcode, ItemsQuery.ModalNumber, Layaway.Qty as QTY, Store.StoreName
FROM         [Transaction] INNER JOIN Layaway ON [Transaction].TransactionID = Layaway.TransactionID INNER JOIN
                      ItemsQuery ON Layaway.ItemStoreID = ItemsQuery.ItemStoreID INNER JOIN
                      Store ON ItemsQuery.StoreNo = Store.StoreID LEFT OUTER JOIN
                      Customer ON [Transaction].CustomerID = Customer.CustomerID
WHERE     ([Transaction].Status > 0) AND ([Transaction].TransactionType IN (14)) '

exec (@MySelect+@Filter)
GO
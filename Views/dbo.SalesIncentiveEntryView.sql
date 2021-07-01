SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE VIEW [dbo].[SalesIncentiveEntryView]
AS
SELECT        dbo.SalesIncentiveEntry.IncentivePercent, dbo.SalesIncentiveEntry.IncentiveAmount, dbo.SalesIncentiveEntry.Posted, dbo.SalesIncentiveEntry.SalesValue, 
                         dbo.SalesIncentiveEntry.SalesIncentiveEntryID, dbo.TransactionEntryItem.StartSaleTime AS SaleDate, dbo.SalesIncentiveEntry.Status, dbo.Users.UserName, 
                         dbo.TransactionEntryItem.Department, dbo.TransactionEntryItem.Name, dbo.TransactionEntryItem.BarcodeNumber, dbo.TransactionEntryItem.QTY, 
                         dbo.TransactionEntryItem.ExtPrice, dbo.TransactionEntryItem.Brand, dbo.TransactionEntryItem.ModalNumber, dbo.Store.StoreName, 
                         dbo.TransactionEntryItem.TransactionNo, dbo.TransactionEntryItem.TransactionID, dbo.TransactionEntryItem.UserID, dbo.TransactionEntryItem.StoreID, 
                         dbo.TransactionEntryItem.DepartmentID, dbo.TransactionEntryItem.ItemStoreID, dbo.SalesIncentiveEntry.TransactionEntryID
FROM            dbo.TransactionEntryItem INNER JOIN
                         dbo.Users ON dbo.TransactionEntryItem.UserID = dbo.Users.UserId INNER JOIN
                         dbo.SalesIncentiveEntry ON dbo.TransactionEntryItem.TransactionEntryID = dbo.SalesIncentiveEntry.TransactionEntryID INNER JOIN
                         dbo.Store ON dbo.TransactionEntryItem.StoreID = dbo.Store.StoreID
WHERE        (dbo.SalesIncentiveEntry.Status > - 1) AND (dbo.Users.Status > - 1)
GO
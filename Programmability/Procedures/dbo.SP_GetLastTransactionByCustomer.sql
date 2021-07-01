SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO



CREATE PROCEDURE [dbo].[SP_GetLastTransactionByCustomer] 
(@CustomerID uniqueidentifier,
 @LastTrans Integer =5)

AS
SELECT        TOP (@LastTrans) [Transaction].TransactionNo, [Transaction].StartSaleTime AS SaleTime, [Transaction].Debit AS TotalSale, [Transaction].TransactionID,ItemsQty
FROM            [Transaction] INNER JOIN
                             (SELECT        TransactionID, SUM(Qty) AS ItemsQty
                               FROM            TransactionEntry
                               WHERE        (TransactionEntryType = 0) AND (Status > 0)
                               GROUP BY TransactionID) AS Items ON [Transaction].TransactionID = Items.TransactionID
WHERE        ([Transaction].CustomerID = @CustomerID) AND
 ([Transaction].Status > 0)
ORDER BY SaleTime DESC
GO
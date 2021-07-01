SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE     VIEW [dbo].[ItemSalesView]
AS
SELECT     dbo.[Transaction].StartSaleTime as SaleTime, dbo.TransactionEntry.ItemStoreID as ItemID, sum(qty) as QtySum
FROM         dbo.[Transaction] INNER JOIN
                      dbo.TransactionEntry ON dbo.[Transaction].TransactionID = dbo.TransactionEntry.TransactionID
WHERE     (dbo.[Transaction].TransactionType = 0) AND (dbo.[Transaction].Status > 0 and transactionEntry.Status>0) 
group by  dbo.[Transaction].StartSaleTime,itemstoreid
GO
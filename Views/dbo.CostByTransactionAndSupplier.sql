SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE     VIEW [dbo].[CostByTransactionAndSupplier]
AS
SELECT     dbo.TransactionEntry.TransactionID, SUM(dbo.TransactionEntry.Cost * dbo.TransactionEntry.Qty) AS SumCost, dbo.ItemSupply.SupplierNo, 
                      dbo.[Transaction].Debit
FROM         dbo.TransactionEntry INNER JOIN
                      dbo.[Transaction] ON dbo.TransactionEntry.TransactionID = dbo.[Transaction].TransactionID and dbo.[Transaction].Status>0 LEFT OUTER JOIN
                      dbo.ItemSupply ON dbo.TransactionEntry.ItemStoreID = dbo.ItemSupply.ItemStoreNo and dbo.ItemSupply.Status>-1
where dbo.TransactionEntry.Status>0 
GROUP BY dbo.TransactionEntry.TransactionID, dbo.ItemSupply.SupplierNo, dbo.[Transaction].Debit
HAVING      (SUM(dbo.TransactionEntry.Cost) > 0)
GO
SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE VIEW [dbo].[Qty&Amount]
AS
SELECT     SUM(dbo.TransactionEntry.Qty) AS QtySum, dbo.[Transaction].StartSaleTime AS SaleDateQA, dbo.[Transaction].Debit, dbo.[Transaction].CustomerID
FROM         dbo.[Transaction] LEFT OUTER JOIN
                      dbo.TransactionEntry ON dbo.[Transaction].TransactionID = dbo.TransactionEntry.TransactionID
WHERE     (dbo.[Transaction].TransactionType = 0) AND (dbo.[Transaction].Status > 0) AND (dbo.TransactionEntry.Status > 0)
GROUP BY dbo.[Transaction].StartSaleTime, dbo.[Transaction].Debit, dbo.[Transaction].CustomerID
GO
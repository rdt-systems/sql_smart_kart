SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE VIEW [dbo].[CostPercentByTransaction]
AS
SELECT     SUM(dbo.ItemStore.Cost) AS SumCost, dbo.TransactionView.TransactionID
FROM         dbo.TransactionEntryView INNER JOIN
                      dbo.TransactionView ON dbo.TransactionEntryView.TransactionID = dbo.TransactionView.TransactionID INNER JOIN
                      dbo.ItemStore ON dbo.TransactionEntryView.ItemStoreID = dbo.ItemStore.ItemStoreID
GROUP BY dbo.TransactionView.TransactionID, dbo.TransactionEntryView.TransactionEntryType
HAVING      (SUM(dbo.ItemStore.Cost) > 0) AND (dbo.TransactionEntryView.TransactionEntryType = 0)
GO
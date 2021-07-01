SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE VIEW [dbo].[JobOrderView]
AS
SELECT        dbo.[Transaction].TransactionNo, dbo.[Transaction].TransactionID, dbo.[Transaction].CustomerID, dbo.JobOrder.JobOrderID, dbo.JobOrder.TransactionEntryID, 
                         dbo.JobOrder.Description, dbo.JobOrder.JobOrderStatus, dbo.TransactionEntryItem.Name, dbo.TransactionEntryItem.BarcodeNumber
FROM            dbo.TransactionEntryItem INNER JOIN
                         dbo.[Transaction] ON dbo.TransactionEntryItem.TransactionID = dbo.[Transaction].TransactionID INNER JOIN
                         dbo.JobOrder ON dbo.TransactionEntryItem.TransactionEntryID = dbo.JobOrder.TransactionEntryID
WHERE        (dbo.JobOrder.Status > 0)
GO
SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE VIEW [dbo].[BatchTenderDetailsView]
AS
SELECT     dbo.[Transaction].BatchID, dbo.TenderEntry.TenderID, dbo.Tender.TenderName, dbo.TenderEntry.Amount, dbo.TenderEntry.Common1 AS ref#, 
                      dbo.CustomerView.Name
FROM         dbo.TenderEntry INNER JOIN
                      dbo.[Transaction] ON dbo.TenderEntry.TransactionID = dbo.[Transaction].TransactionID INNER JOIN
                      dbo.CustomerView ON dbo.[Transaction].CustomerID = dbo.CustomerView.CustomerID INNER JOIN
                      dbo.Tender ON dbo.TenderEntry.TenderID = dbo.Tender.TenderID
WHERE     (dbo.[Transaction].BatchID IS NOT NULL)
GO
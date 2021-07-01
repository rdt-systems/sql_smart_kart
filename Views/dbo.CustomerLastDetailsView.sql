SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE VIEW [dbo].[CustomerLastDetailsView]
AS
SELECT     dbo.CustomerView.CustomerID, MAX(dbo.TransactionView.StartSaleTime) AS LastSale, MAX(TransactionView_1.StartSaleTime) AS LastPayment
FROM         dbo.CustomerView LEFT OUTER JOIN
                      dbo.TransactionView AS TransactionView_1 ON dbo.CustomerView.CustomerID = TransactionView_1.CustomerID AND (TransactionView_1.TransactionType = 1 OR
                      TransactionView_1.Credit > TransactionView_1.Debit) AND TransactionView_1.Status > 0 LEFT OUTER JOIN
                      dbo.TransactionView ON dbo.CustomerView.CustomerID = dbo.TransactionView.CustomerID AND dbo.TransactionView.TransactionType = 0 AND 
                      dbo.TransactionView.Status > 0 
GROUP BY dbo.CustomerView.CustomerID
GO
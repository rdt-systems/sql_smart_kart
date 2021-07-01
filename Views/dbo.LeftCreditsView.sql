SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE VIEW [dbo].[LeftCreditsView]
AS
SELECT     TOP 100 PERCENT dbo.[Transaction].TransactionID, dbo.[Transaction].StartSaleTime, 
                      CASE WHEN dbo.[TRANSACTION].Debit < 0 THEN abs(dbo.[TRANSACTION].Debit - dbo.[TRANSACTION].Credit) - ISNULL(Payments.TotalAmount, 0) 
                      ELSE dbo.[TRANSACTION].Credit - ISNULL(Payments.TotalAmount, 0) END AS LeftCredit, dbo.[Transaction].CustomerID, 
                      dbo.[Transaction].TransactionType
FROM         dbo.[Transaction] LEFT OUTER JOIN
                          (SELECT     TransactionID, SUM(Amount) AS TotalAmount
                            FROM          dbo.PaymentDetails
                            WHERE      (Status > 0)
                            GROUP BY TransactionID) AS Payments ON dbo.[Transaction].TransactionID = Payments.TransactionID
WHERE     (dbo.[Transaction].Status > 0) AND (dbo.[Transaction].StartSaleTime >=
                          dbo.GetCustomerDateStartBalance([Transaction].CustomerID))
ORDER BY dbo.[Transaction].StartSaleTime
GO
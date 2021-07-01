SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SP_GetPaymentsByTransaction]

(@ID uniqueidentifier)

AS 

SELECT CASE WHEN transactiontype = 4 THEN 'Add Charge' WHEN transactiontype = 3 THEN 'Return' WHEN transactiontype = 2 THEN 'Open Balance'
                       ELSE 'Payment' END AS Type, [Transaction].TransactionID, MAX([Transaction].StartSaleTime) AS Date, SUM(PaymentDetails.Amount) 
                      AS Amount, [Transaction].TransactionType, [Transaction].TransactionNo
FROM      [Transaction] INNER JOIN
                      PaymentDetails ON [Transaction].TransactionID = PaymentDetails.TransactionID 
WHERE     (TransactionPayedID = @ID and dbo.PaymentDetails.Status > 0)
GROUP BY dbo.[Transaction].TransactionID  ,transactiontype,[Transaction].TransactionNo
GO
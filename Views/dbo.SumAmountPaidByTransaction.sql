SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE        VIEW [dbo].[SumAmountPaidByTransaction]
AS
SELECT [Transaction].StartSaleTime as DateT,ISNULL(SUM(dbo.PaymentDetails.Amount), 0) AS SumAmount,t.TransactionID
FROM  PaymentDetails Inner Join [Transaction]
on [Transaction].TransactionID=PaymentDetails.TransactionID Inner Join [Transaction] as t
on t.TransactionID=PaymentDetails.TransactionPayedID
where dbo.[Transaction].Status>0 and dbo.PaymentDetails.Status>0 and t.Status>0 
GROUP BY dbo.[Transaction].StartSaleTime,t.TransactionID
GO
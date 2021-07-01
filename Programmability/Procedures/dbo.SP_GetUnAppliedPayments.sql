SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SP_GetUnAppliedPayments]

(@CustomerID uniqueidentifier,
@TransactionID UNIQUEIDENTIFIER)

AS 

SELECT     CASE WHEN transactiontype = 4 THEN 'Add Charge' WHEN transactiontype = 3 THEN 'Return'  WHEN transactiontype = 2 THEN 'Open Balance' ELSE 'Payment' END AS Type, TransactionID, 
                      StartSaleTime AS [Date], (ISNULL(Credit,0)-
--ISNULL(Debit,0)-
ISNULL(AppliedAmount,0)) AS Amount
FROM         dbo.[TransactionWithPaidView] 
WHERE     (Status > 0 AND ISNULL(Credit,0)-
                          --ISNULL(Debit,0)-
                          ISNULL(AppliedAmount,0)>0 AND CustomerID=@CustomerID AND TransactionID<>@TransactionID)
GO
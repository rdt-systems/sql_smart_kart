SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO



CREATE PROCEDURE [dbo].[SP_GetCustomerUnAppliedAmount]
(
@CustomerID UNIQUEIDENTIFIER
)
as

SELECT ISNULL(SUM(ISNULL(Credit,0)-
--ISNULL(Debit,0)-
ISNULL(AppliedAmount,0)),0)
FROM [TransactionWithPaidView]
WHERE (Status>0 And CustomerID=@CustomerID AND ISNULL(Credit,0)-ISNULL(AppliedAmount,0)>0)
GO
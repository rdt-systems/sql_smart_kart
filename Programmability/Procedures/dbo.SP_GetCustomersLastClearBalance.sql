SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SP_GetCustomersLastClearBalance] 
(@date datetime )

AS

SELECT     tr.CustomerID, MAX(tr.StartSaleTime) AS LastTime
FROM         dbo.[Transaction] tr 
WHERE     (tr.TransactionType = 1 or TransactionType=2 or TransactionType=4) AND  Status>0  AND startsaletime>@date and
         ((SELECT     round(SUM(Debit) - SUM(Credit), 2)
          FROM         [TRANSACTION]
          WHERE     [TRANSACTION].customerid = tr.customerid AND startsaletime <= tr.startsaletime and Status>-1) <= 0)

GROUP BY tr.CustomerID
GO
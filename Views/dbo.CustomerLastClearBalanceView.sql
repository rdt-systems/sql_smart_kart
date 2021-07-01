SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE              VIEW [dbo].[CustomerLastClearBalanceView]
AS
SELECT     tr.CustomerID, MAX(tr.StartSaleTime) AS LastClear

FROM         dbo.[Transaction] tr 
WHERE     (TransactionType = 1 OR TransactionType = 2 OR TransactionType = 3 OR TransactionType = 4 or (TransactionType = 0 AND (Credit > 0))) 
			AND (Status > 0) AND (CurrBalance <= 0) 
GROUP BY tr.CustomerID
GO
SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE VIEW [dbo].[CustomerTotalSaleView]
AS
SELECT     CustomerID, SUM(Debit) AS SumDebit
FROM         dbo.[Transaction]
GROUP BY CustomerID
HAVING      (CustomerID IS NOT NULL)
GO
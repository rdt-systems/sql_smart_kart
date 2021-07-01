SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE     VIEW [dbo].[OnlySales]
AS
SELECT     StartSaleTime AS SaleDate, CustomerID
FROM         dbo.[Transaction]
WHERE     (TransactionType = 0)
GO
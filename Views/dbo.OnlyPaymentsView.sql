SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE     VIEW [dbo].[OnlyPaymentsView]
AS
SELECT     CustomerID, StartSaleTime
FROM         dbo.[Transaction]
WHERE     (TransactionType = 1)
GO
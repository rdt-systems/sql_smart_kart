SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE    VIEW [dbo].[LeftDebitsView]
AS
SELECT     TOP 100 PERCENT TransactionID, StartSaleTime, ISNULL(DueDate, StartSaleTime) AS DueDate, ISNULL(LeftDebit, 0) AS LeftDebit, CustomerID
FROM         dbo.[Transaction]
WHERE     (Debit > 0) AND (Status > 0) and StartSaleTime>=dbo.GetCustomerDateStartBalance([Transaction].CustomerID)
ORDER BY StartSaleTime
GO
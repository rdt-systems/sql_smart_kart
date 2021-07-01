SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE VIEW [dbo].[CustomerSalesAndClearInfo]
WITH SCHEMABINDING
AS
Select CustomerID,  StartSaleTime, CurrBalance, TransactionType from dbo.[Transaction] 
Where Status > 0 and CustomerID IS NOT NULL 

GO
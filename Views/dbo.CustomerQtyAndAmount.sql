SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE        VIEW [dbo].[CustomerQtyAndAmount]
AS
SELECT     SUM(QtySum) AS TotalQty, SUM(Debit) AS TotalDebit, CustomerID,(select DateCreated from dbo.Customer where CustomerID=[Qty&Amount].CustomerID)as DateCreated
FROM         dbo.[Qty&Amount]
GROUP BY CustomerID
GO
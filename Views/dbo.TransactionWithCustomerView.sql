SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE VIEW [dbo].[TransactionWithCustomerView]
AS
SELECT     *
FROM         dbo.[Transaction]
WHERE     (CustomerID IS NOT NULL)
GO
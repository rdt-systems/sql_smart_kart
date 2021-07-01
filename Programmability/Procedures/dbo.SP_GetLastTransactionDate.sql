SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SP_GetLastTransactionDate]
(@StoreID uniqueidentifier)
AS SELECT     isnull(MAX(StartSaleTime),dbo.GetLocalDATE()) AS Expr1
FROM         dbo.TransactionView
WHERE     (StoreID = @StoreID)
GO
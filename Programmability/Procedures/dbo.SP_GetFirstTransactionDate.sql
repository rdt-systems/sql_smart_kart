SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SP_GetFirstTransactionDate](@StoreID uniqueidentifier)
AS SELECT     isnull(MIN(StartSaleTime),dbo.GetLocalDATE()) AS Expr1
FROM         dbo.TransactionView
WHERE     (StoreID = @StoreID)
GO
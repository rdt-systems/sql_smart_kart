SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SP_GetLastAPTransactionDate]
(@StoreID uniqueidentifier = NULL)
AS SELECT     isnull(MAX(DateT),dbo.GetLocalDATE()) AS Expr1
FROM         dbo.AllTransactionForSupplier
WHERE     (StoreNo = @StoreID Or @StoreID IS NULL)
GO
SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SP_GetFirstAPTransactionDate]
(@StoreID uniqueidentifier = Null)
AS
SELECT     isnull(MIN(DateT),dbo.GetLocalDATE()) AS Expr1
FROM       dbo.AllTransactionForSupplier
WHERE     (StoreNo = @StoreID Or @StoreID IS NULL)
GO
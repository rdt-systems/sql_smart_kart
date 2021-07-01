SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE proc [dbo].[SP_SaleToStoreDelete]
(	@SaleToStoreID uniqueidentifier
	,@ModifierID uniqueidentifier
)
as


UPDATE [dbo].[SaleToStore]
   SET 
      [Status] = -1
      ,[DateModified] = dbo.GetLocalDATE()
      ,[UserModifed] = @ModifierID
 WHERE [SaleToStoreID] = @SaleToStoreID
GO
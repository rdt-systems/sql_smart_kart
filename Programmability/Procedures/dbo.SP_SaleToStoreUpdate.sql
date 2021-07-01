SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE proc [dbo].[SP_SaleToStoreUpdate]
(	@SaleToStoreID uniqueidentifier
	,@SaleID uniqueidentifier
	,@StoreID uniqueidentifier
	,@ActivationStatus int
    ,@Status smallint
	,@DateModified datetime
	,@ModifierID uniqueidentifier
)
as

Declare @UpdateTime datetime
set  @UpdateTime =dbo.GetLocalDATE()


UPDATE [dbo].[SaleToStore]
   SET [SaleID] = @SaleID
      ,[StoreID] = @StoreID
      ,[ActivationStatus] = @ActivationStatus
      ,[Status] = @Status
      ,[DateModified] = dbo.GetLocalDATE()
      ,[UserModifed] = @ModifierID
 WHERE [SaleToStoreID] = @SaleToStoreID AND 
		(DateModified = @DateModified OR DateModified IS NULL)


select @UpdateTime as DateModified
GO
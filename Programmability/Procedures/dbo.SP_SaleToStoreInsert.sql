SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE proc [dbo].[SP_SaleToStoreInsert]
(	@SaleToStoreID uniqueidentifier
	,@SaleID uniqueidentifier
	,@StoreID uniqueidentifier
	,@ActivationStatus int
    ,@Status smallint
	,@ModifierID uniqueidentifier
	
)
as
INSERT INTO [dbo].[SaleToStore]
           ([SaleToStoreID]
           ,[SaleID]
           ,[StoreID]
           ,[ActivationStatus]
           ,[Status]
           ,[DateCreated]
           ,[UserCreated]
           ,[DateModified]
           ,[UserModifed])
     VALUES
           (@SaleToStoreID
           ,@SaleID
           ,@StoreID
           ,@ActivationStatus
           ,isnull(@Status,1)
           ,dbo.GetLocalDATE()
           ,@ModifierID
           ,dbo.GetLocalDATE()
           ,@ModifierID)
GO
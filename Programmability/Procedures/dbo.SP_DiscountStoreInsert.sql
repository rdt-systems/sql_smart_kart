SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SP_DiscountStoreInsert]
(           @DiscountStoreID uniqueidentifier
           ,@DiscountID uniqueidentifier
           ,@StoreID uniqueidentifier
           ,@Status smallint,
		    @ModifierID uniqueidentifier
)
AS
INSERT INTO [dbo].[DiscountStore]
           ([DiscountStoreID]
           ,[DiscountID]
           ,[StoreID]
           ,[Status]
           ,[DateCreated]
           ,[UserCreated]
           ,[DateModified]
           )
     VALUES
           (@DiscountStoreID
           ,@DiscountID
           ,@StoreID
           ,@Status
           ,dbo.GetLocalDATE()
           ,@ModifierID
           ,dbo.GetLocalDATE()
           )
GO
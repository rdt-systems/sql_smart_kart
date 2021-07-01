SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SP_DiscountItemInsert]
(           @ItemDiscountID uniqueidentifier
           ,@DiscountID uniqueidentifier
           ,@ItemID uniqueidentifier
           ,@Status smallint,
		    @ModifierID uniqueidentifier
)
AS
INSERT INTO [dbo].[DiscountItem]
           ([ItemDiscountID]
           ,[DiscountID]
           ,[ItemID]
           ,[Status]
           ,[DateCreated]
           ,[UserCreated]
           ,[DateModified]
           )
     VALUES
           (@ItemDiscountID
           ,@DiscountID
           ,@ItemID
           ,@Status
           ,dbo.GetLocalDATE()
           ,@ModifierID
           ,dbo.GetLocalDATE()
           )
GO
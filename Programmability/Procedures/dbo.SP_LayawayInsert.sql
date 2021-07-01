SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SP_LayawayInsert]
           (@LayawayID uniqueidentifier
           ,@ItemStoreID uniqueidentifier
           ,@Price money
           ,@Qty money
           ,@Status int
           --,@DateCreated datetime
           --,@DateModified datetime
           ,@UserCREATEd uniqueidentifier
           ,@UserModified uniqueidentifier
           ,@LayawayStatus int
           ,@TransactionID uniqueidentifier)
AS          
           INSERT INTO [Layaway]
           ([LayawayID]
           ,[ItemStoreID]
           ,[Price]
           ,[Qty]
           ,[Status]
           ,[DateCreated]
           ,[DateModified]
           ,[UserCreate]
           ,[UserModified]
           ,[LayawayStatus]
           ,[TransactionID])
     VALUES
           (@LayawayID
           ,@ItemStoreID
           ,@Price
           ,@Qty
           ,@Status
           ,dbo.GetLocalDATE()
           ,dbo.GetLocalDATE()
           ,@UserCreated
           ,@UserModified
           ,@LayawayStatus
           ,@TransactionID)

	IF  (@LayawayStatus =1) 
	BEGIN
	  UPDATE ItemStore SET OnHand = IsNull(OnHand,0)-@Qty WHERE ItemStoreID =@ItemStoreID 
	END
GO
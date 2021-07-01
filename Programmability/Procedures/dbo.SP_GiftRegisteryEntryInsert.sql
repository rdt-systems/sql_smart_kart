SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SP_GiftRegisteryEntryInsert]
           (@GiftRegisteryEntryID uniqueidentifier
           ,@GiftRegisteryID uniqueidentifier
           ,@ItemID uniqueidentifier
           ,@QtyRequested int
           ,@QtyReceived int=0
           ,@Status int)
AS 
   INSERT INTO [dbo].[GiftRegisteryEntry]
           ([GiftRegisteryEntryID]
           ,[GiftRegisteryID]
           ,[ItemID]
           ,[QtyRequested]
           ,[QtyReceived]
           ,[DateCreated]
           ,[Status])
     VALUES
           (@GiftRegisteryEntryID 
           ,@GiftRegisteryID
           ,@ItemID
           ,@QtyRequested
           ,@QtyReceived
           ,dbo.GetLocalDATE()
           ,@Status)
GO
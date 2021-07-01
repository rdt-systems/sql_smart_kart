SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SP_GiftRegisteryEntryUpdate]
           (@GiftRegisteryEntryID uniqueidentifier
           ,@GiftRegisteryID uniqueidentifier
           ,@ItemID uniqueidentifier
           ,@QtyRequested int
           ,@QtyReceived int =0
           ,@Status int)
AS 
   
UPDATE [dbo].[GiftRegisteryEntry]
   SET [GiftRegisteryID] = @GiftRegisteryID
      ,[ItemID] = @ItemID
      ,[QtyRequested] =@QtyRequested
--    ,[QtyReceived] = <QtyReceived, int,>
--    ,[DateCREATE] = <DateCREATE, datetime,>
      ,[DateModified] = dbo.GetLocalDATE()
      ,[Status] = @Status
 WHERE GiftRegisteryEntryID = @GiftRegisteryEntryID
GO
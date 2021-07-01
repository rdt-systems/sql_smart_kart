SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SP_TransEntryToRegEntryInsert]
           (@TransEntryToRegEntryID uniqueidentifier,
            @TransEntryID uniqueidentifier,
            @RegEntryID uniqueidentifier,
            @Qty decimal(18, 0),
            @Status int)
AS
INSERT INTO [TransEntryToRegEntry]
           ([TransEntryToRegEntryID]
           ,[TransEntryID]
           ,[RegEntryID]
           ,[Status]
           ,[DateCreated])
     VALUES
           (@TransEntryToRegEntryID
           ,@TransEntryID
           ,@RegEntryID
           ,@Status
           ,dbo.GetLocalDATE())
           
   UPDATE GiftRegisteryEntry Set QtyReceived = (QtyReceived + @qty) 
   WHERE GiftRegisteryEntryID = @RegEntryID
GO
SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SP_ReceiveTransferInsert]
	(@ReceiveTransferID uniqueidentifier,
           @ReceiveDate datetime,
           @ReciveNo nvarchar(20),
           @StoreID uniqueidentifier,
           @TransferID uniqueidentifier,
           @ModifierID uniqueidentifier,
           @Status int)

AS


Declare @UpdateTime datetime
set  @UpdateTime =dbo.GetLocalDATE()

INSERT INTO [dbo].[ReceiveTransfer]
           ([ReceiveTransferID]
           ,[ReceiveDate]
           ,[ReciveNo]
           ,[StoreID]
           ,[TransferID]
           ,[DateCreate]
           ,[DateModified]
           ,[UserCreate]
           ,[UserModified]
           ,[Status])
     VALUES
           (@ReceiveTransferID,
           @ReceiveDate,
		   @ReciveNo,
           @StoreID, 
           @TransferID,
		   @UpdateTime, 
           @UpdateTime, 
           @ModifierID, 
           @ModifierID, 
           @Status )
GO
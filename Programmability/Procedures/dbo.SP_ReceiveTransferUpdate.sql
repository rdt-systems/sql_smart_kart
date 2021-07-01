SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SP_ReceiveTransferUpdate]
	(@ReceiveTransferID uniqueidentifier,
           @ReceiveDate datetime,
           @ReciveNo nvarchar(20),
           @StoreID uniqueidentifier,
           @TransferID uniqueidentifier,
		   @DateModified datetime=null,
           @ModifierID uniqueidentifier,
           @Status int)

AS

Declare @UpdateTime datetime
set  @UpdateTime =dbo.GetLocalDATE()

UPDATE [dbo].[ReceiveTransfer]
   SET [ReceiveDate] = @ReceiveDate
      ,[ReciveNo] = @ReciveNo
      ,[StoreID] = @StoreID
      ,[TransferID] = @TransferID
      ,[DateModified] = @UpdateTime
      ,[UserModified] = @ModifierID 
      ,[Status] = @Status
 WHERE [ReceiveTransferID] = @ReceiveTransferID

 If @Status <= 0
 Update TransferItems SET TransferStatus = 1, DateModified = dbo.GetLocalDate() Where TransferID = @TransferID
GO
SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SP_ReceiveTransferDelete]
	@ReceiveTransferID uniqueidentifier,
	@ModifierID uniqueidentifier
AS

	update dbo.ReceiveTransfer
	set Status = -1, DateModified = dbo.GetLocalDATE(),
		UserModified = @ModifierID
	where [ReceiveTransferID] = @ReceiveTransferID
GO
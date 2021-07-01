SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SP_TransferItemsDelete]
(@TransferID uniqueidentifier,
@ModifierID uniqueidentifier)

AS 
if (select status From TransferItems Where TransferID=@TransferID)<>0
exec UpdateOnHandByTransfer @TransferID,-1,@ModifierID

Update dbo.TransferItems
SET    status=-1, DateModified = dbo.GetLocalDATE(), UserModified =@ModifierID
WHERE   TransferID=@TransferID

exec UpdateOnHandByTransfer @TransferID,-1,@ModifierID
GO
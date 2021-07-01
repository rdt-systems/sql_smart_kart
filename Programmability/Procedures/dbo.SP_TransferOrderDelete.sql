SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SP_TransferOrderDelete]
(@TransferOrderID uniqueidentifier,
@ModifierID uniqueidentifier)

AS 
if (select status From TransferOrder Where TransferOrderID=@TransferOrderID)<>0
exec UpdateOnOrderAndOnTransfer @TransferOrderID,-1,@ModifierID

Update dbo.TransferOrder
SET    status=-1, DateModified = dbo.GetLocalDATE(), UserModified =@ModifierID
WHERE   TransferOrderID=@TransferOrderID
GO
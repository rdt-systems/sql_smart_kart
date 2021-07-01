SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SP_ReceiveOrderDelete]

(@ReceiveID uniqueidentifier, 
@ModifierID  uniqueidentifier) 

AS

exec UpdateReceiveEntry @ReceiveID,-1,@ModifierID

UPDATE   dbo.ReceiveOrder
SET       Status = -1 , DateModified = dbo.GetLocalDATE(), UserModified = @ModifierID
WHERE  ReceiveID  = @ReceiveID
GO
SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[Sync_ReceiveDelete]
(
@ReceiveID uniqueidentifier,
@ModifierID uniqueidentifier
)
as

IF (SELECT  count(*) FROM dbo.ReceiveOrder WHERE ReceiveID = @ReceiveID)>0
	exec [DeleteReceive] @ReceiveID, @ModifierID

else if (SELECT  count(*) FROM dbo.ReturnToVender WHERE ReturnToVenderID = @ReceiveID)>0
	exec [DeleteReturn] @ReceiveID, @ModifierID
	
else if (SELECT  count(*) FROM dbo.SupplierTenderEntry WHERE SuppTenderEntryID = @ReceiveID)>0
	exec [DeletePayment] @ReceiveID, @ModifierID
GO
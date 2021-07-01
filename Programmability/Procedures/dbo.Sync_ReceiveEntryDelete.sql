SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[Sync_ReceiveEntryDelete]
(
@ReceiveEntryID uniqueidentifier,
@ModifierID uniqueidentifier)


as

if ((SELECT count(*) FROM dbo.ReceiveEntry WHERE ReceiveEntryID = @ReceiveEntryID)>0)
	exec [SP_ReceiveEntryDelete] @ReceiveEntryID,0, @ModifierID

else if ((SELECT count(*) FROM dbo.ReturnToVenderEntry WHERE ReturnToVenderEntryID = @ReceiveEntryID)>0)
	exec[SP_ReturnToVenderEntryDelete] @ReceiveEntryID, @ModifierID
GO
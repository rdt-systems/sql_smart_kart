SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[Sync_TransactionEntryDelete]
(@TransactionEntryID uniqueidentifier,
@ModifierID uniqueidentifier)

as 

if (SELECT count(*)
	FROM [TransactionEntry]
	Where TransactionEntryID=@TransactionEntryID)>0

	exec [SP_TransactionEntryDelete]
	@TransactionEntryID,@ModifierID 

else
if (SELECT count(*)
	FROM WorkOrderEntry
	Where WorkOrderEntryID=@TransactionEntryID)>0

 exec SP_WorkOrderEntryDelete @TransactionEntryID,@ModifierID
GO
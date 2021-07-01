SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[Sync_TransactionDelete]
(@TransactionID uniqueidentifier,
 @ModifierID uniqueidentifier)
as

if (SELECT count(*)
	FROM [Transaction]
	Where TransactionID=@TransactionID)>0

Exec [SP_TransactionDelete] @TransactionID ,@ModifierID

else

Exec [SP_WorkOrderDelete] @TransactionID ,@ModifierID
GO
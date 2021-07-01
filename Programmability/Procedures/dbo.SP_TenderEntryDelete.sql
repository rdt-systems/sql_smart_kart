SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SP_TenderEntryDelete]
@TenderEntryId uniqueidentifier,
@ModifierID uniqueidentifier
AS

UPDATE  dbo.TenderEntry
SET      status = -1, DateModified = dbo.GetLocalDATE(),  UserModified = @ModifierID
WHERE   TenderEntryId = @TenderEntryId

UPDATE  dbo.W_TenderEntry
SET      status = -1, DateModified = dbo.GetLocalDATE(),  UserModified = @ModifierID
WHERE   TenderEntryId = @TenderEntryId

	DECLARE @GiftToTenderID uniqueidentifier
	
	DECLARE DelEntry CURSOR LOCAL FORWARD_ONLY STATIC OPTIMISTIC FOR
	SELECT GiftToTenderID
	FROM dbo.GiftToTender WHERE(TenderEntryId=@TenderEntryId) 
	
	OPEN DelEntry
	
	FETCH NEXT FROM DelEntry 
	INTO @GiftToTenderID   -- holds the current transaction entry
	
	WHILE @@FETCH_STATUS = 0
		BEGIN
			exec SP_GiftToTenderDelete @GiftToTenderID,@ModifierID
		FETCH NEXT FROM DelEntry    --insert the next values to the instance
			INTO @GiftToTenderID
		END
	
	CLOSE DelEntry
	DEALLOCATE DelEntry
GO
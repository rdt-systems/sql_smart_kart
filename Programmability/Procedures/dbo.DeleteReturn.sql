SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[DeleteReturn]
(@ReturnID uniqueidentifier,@ModifierID uniqueidentifier)

as

DECLARE @EntryID uniqueidentifier

UPDATE   dbo.ReturnToVender
SET      Status = -1 ,
	     DateModified = dbo.GetLocalDATE(), 
	     UserModified = @ModifierID
WHERE    ReturnToVenderID  = @ReturnID

DECLARE c2 CURSOR FORWARD_ONLY STATIC OPTIMISTIC FOR
SELECT PayToBillID
FROM dbo.PayToBill WHERE(SuppTenderID = @ReturnID) 

OPEN c2

FETCH NEXT FROM c2 
INTO @EntryID   

WHILE @@FETCH_STATUS = 0
	BEGIN
		exec dbo.SP_PayToBillDelete @EntryID,0,@ModifierID
	FETCH NEXT FROM c2    
		INTO @EntryID
	END

CLOSE c2
DEALLOCATE c2

DECLARE c1 CURSOR FORWARD_ONLY STATIC OPTIMISTIC FOR
SELECT ReturnToVenderEntryID
FROM dbo.ReturnToVenderEntry WHERE(ReturnToVenderID=@ReturnID) 

OPEN c1

FETCH NEXT FROM c1 
INTO @EntryID   

WHILE @@FETCH_STATUS = 0
	BEGIN
		exec dbo.SP_ReturnToVenderEntryDelete @EntryID,@ModifierID
	FETCH NEXT FROM c1    
		INTO @EntryID
	END

CLOSE c1
DEALLOCATE c1
GO
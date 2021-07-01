SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SP_ReturnToVenderEntryDelete]
(@ReturnToVenderEntryID uniqueidentifier,
@ModifierID uniqueidentifier)

As
Declare @OldStatus Decimal 
Set @OldStatus =(Select Status From dbo.ReturnToVenderEntry where  ReturnToVenderEntryID = @returnToVenderEntryID)

Declare @ItemStoreNo uniqueidentifier
SET @ItemStoreNo = (SELECT ItemStoreNo FROM dbo.ReturnToVenderEntry WHERE ReturnToVenderEntryID = @returnToVenderEntryID)

UPDATE ReturnToVenderEntry
SET  Status = -1,  DateModified = dbo.GetLocalDATE(), UserModified =@ModifierID
WHERE ReturnToVenderEntryID = @returnToVenderEntryID

if @OldStatus=1
begin
Declare @Qty decimal(19,3)
set @Qty=(SELECT Qty  FROM dbo.ReturnToVenderEntry WHERE ReturnToVenderEntryID = @ReturnToVenderEntryID)

UPDATE dbo.ItemStore
SET 	OnHand = isnull(OnHand,0) + @Qty, 
	    DateModified = dbo.GetLocalDATE(), 
	    UserModified = @ModifierID
WHERE ItemStoreID = @ItemStoreNo

EXEC UpdateAPParent @ItemStoreNo,@ModifierID,0,1,0,@Qty

end
GO
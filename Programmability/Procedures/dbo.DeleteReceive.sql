SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[DeleteReceive]
(@ReceiveID uniqueidentifier,@ModifierID uniqueidentifier)

as

UPDATE   dbo.ReceiveOrder
SET      Status = -1 ,
	 DateModified = dbo.GetLocalDATE(), 
	 UserModified = @ModifierID
WHERE    ReceiveID  = @ReceiveID

UPDATE   dbo.Bill
SET      Status=-1, 
         DateModified = dbo.GetLocalDATE(), 
	 UserModified =@ModifierID
WHERE    BillID = (Select BillID from ReceiveOrderView where ReceiveID=@ReceiveID)

UPDATE   dbo.PayToBill
SET      Status = -1 ,
	 DateModified =dbo.GetLocalDATE(), 
         UserModified  = @ModifierId
where    BillID = (Select BillID from ReceiveOrderView where ReceiveID=@ReceiveID)

UPDATE   dbo.ReceiveToPO
SET      Status = -1 ,
	     DateModified =dbo.GetLocalDATE(), 
         UserModified  = @ModifierId
where    ReceiveID = @ReceiveID


declare @ReceiveEntryID uniqueidentifier
declare C cursor  for select ReceiveEntryID  from ReceiveEntry WHERE(ReceiveNo=@ReceiveID)
OPEN C

fetch next from C into @ReceiveEntryID
while @@fetch_status = 0 begin
EXEC	[dbo].[SP_ReceiveEntryDelete]
		@ReceiveEntryID = @ReceiveEntryID,
		@ModifierID = @ModifierID
fetch next from C into @ReceiveEntryID
end
close C 
deallocate C
GO
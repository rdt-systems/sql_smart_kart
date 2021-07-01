SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SP_DeleteOneReceive]
(@No nvarchar(50),
@ModifierID uniqueidentifier,
@Type int)


AS 
Declare @ReceiveID uniqueidentifier
Declare @BillID uniqueidentifier
DECLARE @EntryID uniqueidentifier

--Receive

if             (@Type=2) 
Begin

set @ReceiveID=(select top 1 ReceiveID 
		from dbo.ReceiveOrderView 
		where BillNo=@No AND Status>0)
set @BillID=   (select top 1 BillID 
		from dbo.ReceiveOrderView 
		where BillNo=@No AND Status>0)

UPDATE   dbo.ReceiveOrder
SET      Status = -1 ,
	 DateModified = dbo.GetLocalDATE(), 
	 UserModified = @ModifierID
WHERE    ReceiveID  = @ReceiveID

UPDATE   dbo.Bill
SET      Status=-1, 
         DateModified = dbo.GetLocalDATE(), 
	 UserModified =@ModifierID
WHERE    BillID = @BillID

UPDATE   dbo.PayToBill
SET      Status = -1 ,
	 DateModified =dbo.GetLocalDATE(), 
         UserModified  = @ModifierId
where    BillID = @BillID

UPDATE   dbo.ReceiveToPO
SET      Status = -1 ,
	 DateModified =dbo.GetLocalDATE(), 
         UserModified  = @ModifierId
where    ReceiveID = @ReceiveID

DECLARE c1 CURSOR FORWARD_ONLY STATIC OPTIMISTIC FOR
SELECT ReceiveEntryID
FROM dbo.ReceiveEntry WHERE(ReceiveNo=@ReceiveID) 

OPEN c1

FETCH NEXT FROM c1 
INTO @EntryID   

WHILE @@FETCH_STATUS = 0
	BEGIN
		exec dbo.SP_ReceiveEntryDelete @EntryID,0,@ModifierID
	FETCH NEXT FROM c1    
		INTO @EntryID
	END

CLOSE c1
DEALLOCATE c1
end 

--Return

else
if             (@Type=3)
begin

set      @ReceiveID=(select top 1 ReturnToVenderID 
		     from dbo.ReturnToVender
		     where ReturnToVenderNo=@No AND Status>0)

UPDATE   dbo.ReturnToVender
SET      Status = -1 ,
	 DateModified = dbo.GetLocalDATE(), 
	 UserModified = @ModifierID
WHERE    ReturnToVenderID= @ReceiveID

DECLARE c1 CURSOR FORWARD_ONLY STATIC OPTIMISTIC FOR
SELECT PayToBillID
FROM dbo.PayToBill 
WHERE    SuppTenderID= @ReceiveID

OPEN c1

FETCH NEXT FROM c1 
INTO @EntryID   

WHILE @@FETCH_STATUS = 0
	BEGIN
		exec dbo.SP_PayToBillDelete @EntryID,@ModifierID
	FETCH NEXT FROM c1    
		INTO @EntryID
	END

CLOSE c1
DEALLOCATE c1

DECLARE c1 CURSOR FORWARD_ONLY STATIC OPTIMISTIC FOR
SELECT ReturnToVenderEntryID
FROM dbo.ReturnToVenderEntry WHERE(ReturnToVenderID=@ReceiveID) 

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
end
else

--Payment

if             (@Type=5)
begin

set      @ReceiveID=(select top 1  SuppTenderEntryID
		     from dbo.SupplierTenderEntry
		     where SuppTenderNo=@No AND Status>0)

UPDATE   dbo.SupplierTenderEntry
SET      Status = -1 ,
	 DateModified = dbo.GetLocalDATE(), 
	 UserModified = @ModifierID
WHERE    SuppTenderEntryID= @ReceiveID


DECLARE c1 CURSOR FORWARD_ONLY STATIC OPTIMISTIC FOR
SELECT PayToBillID
FROM dbo.PayToBill 
WHERE    SuppTenderID= @ReceiveID

OPEN c1

FETCH NEXT FROM c1 
INTO @EntryID   

WHILE @@FETCH_STATUS = 0
	BEGIN
		exec dbo.SP_PayToBillDelete @EntryID,@ModifierID
	FETCH NEXT FROM c1    
		INTO @EntryID
	END

CLOSE c1
DEALLOCATE c1


end
GO
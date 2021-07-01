SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO




CREATE PROCEDURE [dbo].[VoidReceive]
(@ReceiveID uniqueidentifier,@ModifierID uniqueidentifier)

as

exec UpdateReceiveEntry @ReceiveID,-1,@ModifierID

UPDATE   dbo.ReceiveOrder
SET      Status = 0,
	 DateModified = dbo.GetLocalDATE(), 
	 UserModified = @ModifierID
WHERE    ReceiveID  = @ReceiveID

UPDATE   dbo.Bill
SET      Status=0,
		 AmountPay=0,
         DateModified = dbo.GetLocalDATE(), 
	     UserModified =@ModifierID
WHERE    BillID = (Select BillID from ReceiveOrderView where ReceiveID=@ReceiveID)

UPDATE   dbo.PayToBill
SET      Status = 0 ,
	     DateModified =dbo.GetLocalDATE(), 
         UserModified  = @ModifierId
where    BillID = (Select BillID from ReceiveOrderView where ReceiveID=@ReceiveID)

UPDATE   dbo.ReceiveToPO
SET      Status = 0 ,
	     DateModified =dbo.GetLocalDATE(), 
         UserModified  = @ModifierId
where    ReceiveID = @ReceiveID

UPDATE  dbo.ReceiveEntry              
SET     Status = 0 ,
	    DateModified = dbo.GetLocalDATE(),       
	    UserModified = @ModifierID
WHERE(ReceiveNo=@ReceiveID)





Declare @ItemStoreID Uniqueidentifier

Declare Ro  CURSOR For
SELECT ItemStoreNo From ReceiveEntry 
Where ReceiveNo=@ReceiveID

Open Ro

FETCH NEXT FROM Ro
Into @ItemStoreID

WHILE @@FETCH_STATUS = 0
Begin

Exec SP_UpdateOnHandOneItem @ItemStoreID


update itemstore 
set itemstore.LastReceivedDate=orders.ReceiveOrderDate ,  itemstore.LastReceivedQty=orders.qty
from (
select ROW_NUMBER()  over (partition by ItemStoreno order by ReceiveOrder.ReceiveOrderDate desc )as rr ,ReceiveOrder.ReceiveOrderDate,ReceiveEntry.qty,ReceiveEntry.ItemStoreno
from ReceiveEntry join ReceiveOrder  
on ReceiveEntry.ReceiveNo =ReceiveOrder.ReceiveID
where ItemStoreno = @ItemStoreID
) as orders  join itemstore  on orders.ItemStoreno =itemstore.ItemStoreID
where rr=1

FETCH NEXT FROM Ro
Into @ItemStoreID
END

CLOSE Ro

DEALLOCATE Ro
GO
SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE procedure [dbo].[UpdatePOStatus]
(@POID uniqueidentifier,
@ModifierID uniqueidentifier, @ClosePO as int, @PONO as nvarchar(50))

as

Declare @UpdateTime datetime
set  @UpdateTime =dbo.GetLocalDATE()

Declare @OpenItemsCount int

	SELECT QtyOrdered,PurchaseOrderNo,(Case WHEN QtyOrdered > isnull(ReceivedQty, 0) THEN 
	QtyOrdered - isnull(ReceivedQty, 0) 
	ELSE
	 0 
	END) AS OrderDeficit into #Temp1
	
	FROM  dbo.PurchaseOrderEntry LEFT OUTER JOIN
	                          (SELECT     SUM(Qty) AS ReceivedQty, PurchaseOrderEntryNo
	                            FROM          dbo.ReceiveEntry
				    where Status>0
	                            GROUP BY PurchaseOrderEntryNo) Receives
	           ON Receives.PurchaseOrderEntryNo = dbo.PurchaseOrderEntry.PurchaseOrderEntryId
	Where dbo.PurchaseOrderEntry.PurchaseOrderNo=@POID and Status>0

Set @OpenItemsCount=(Select Count(*) from #Temp1 Where OrderDeficit>0)

if @OpenItemsCount=0 or @ClosePO = 1
begin
	update 	PurchaseOrders
	Set 	POStatus=2,--Close
		    DateModified=@UpdateTime,
		    UserModified=@ModifierID
	where 	PurchaseOrderId =@POID
end	
else
begin

	Declare @OrderedCount Decimal
	Set @OrderedCount=(Select Sum(QtyOrdered) from #Temp1 where (PurchaseOrderNo=@POID))

	Declare @DeficitCount Decimal
	Set @DeficitCount=(Select Sum(OrderDeficit) from #Temp1 where (PurchaseOrderNo=@POID))

	if (@OrderedCount=@DeficitCount)
		update 	PurchaseOrders
		Set 	POStatus=0,--Open
			    DateModified=@UpdateTime,
			    UserModified=@ModifierID
		where 	PurchaseOrderId =@POID
	else
		update 	PurchaseOrders
		Set 	POStatus=1,--Partial
				DateModified=@UpdateTime,
				UserModified=@ModifierID
		where 	PurchaseOrderId =@POID
end

--Alex Abreu: if the PONO has value then close the order (12/17/2015)
if @PONO <> ''
Begin
	update 	PurchaseOrders
	Set 	POStatus=2,--Close
		    DateModified=@UpdateTime,
		    UserModified=@ModifierID
	where 	PoNo=@PONO
end
	
drop TABLE #Temp1

Declare @ItemNo uniqueidentifier
DECLARE PO1 CURSOR FORWARD_ONLY STATIC OPTIMISTIC FOR
SELECT ItemNo FROM PurchaseOrderEntryView Where PurchaseOrderNO=@PoID

OPEN PO1

FETCH NEXT FROM PO1
INTO @ItemNo

WHILE  @@FETCH_STATUS = 0
BEGIN

    	Exec UpdateOnOrderByOrder  @ItemNo,@ModifierID
    
	FETCH NEXT FROM PO1
	INTO @ItemNo
END

CLOSE PO1
DEALLOCATE PO1



select @UpdateTime as DateModified
GO
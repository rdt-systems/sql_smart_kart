SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE procedure [dbo].[UpdateAPParent]
(@ItemStoreID  uniqueidentifier,
@ModifierID Uniqueidentifier,

@Receive bit,
@Return bit, 
@Order  Bit,

@Qty decimal(19,3))

As 

Declare @StoreID Uniqueidentifier
Set @StoreID=(Select StoreNo from ItemStore Where ItemStoreID=@ItemStoreID)

Declare @LinkNo Uniqueidentifier
Set @LinkNo=(Select ItemStoreID 
             FROM ItemMain inner Join 
             ItemStore On ItemNo=ItemID and StoreNo = @StoreID
             Where  ItemID=(Select LinkNo
                            From ItemMain 
                            where ItemID=
                           (Select ItemNo from ItemStore Where ItemStoreID=@ItemStoreID)))


if @Receive = 1 Or @Return = 1 
	BEGIN 

			UPDATE dbo.ItemStore
			SET OnHand = isnull(OnHand,0) + @Qty , 
				DateModified = dbo.GetLocalDATE(), 
				UserModified = @ModifierID
			WHERE ItemStoreID = @LinkNo

	END 

ELSE

if @Order=1
	BEGIN
      
		SELECT   ItemNo ,(CASE  when dbo.PurchaseOrders.POStatus =2 then 0 else (Case WHEN QtyOrdered > isnull(ReceivedQty, 0) THEN 
		QtyOrdered - isnull(ReceivedQty, 0) 
		ELSE
		 0 
		END)end) AS OrderDeficit  into #MyTemp1
		FROM       dbo.PurchaseOrderEntry LEFT OUTER JOIN
									(SELECT     SUM(Qty) AS ReceivedQty, PurchaseOrderEntryNo
									FROM          dbo.ReceiveEntry
						where Status>0
									GROUP BY PurchaseOrderEntryNo) Receives
				   ON Receives.PurchaseOrderEntryNo = dbo.PurchaseOrderEntry.PurchaseOrderEntryId
		LEFT OUTER JOIN 
		dbo.PurchaseOrders On PurchaseOrders.PurchaseOrderId=PurchaseOrderEntry.PurchaseOrderNo
		where PurchaseOrderEntry.Status>0 And
              PurchaseOrderEntry.ItemNo in (Select ItemStoreID 
                                            FROM ItemMain inner Join 
                                                 ItemStore On ItemNo=ItemID and StoreNo = @StoreID
                                            Where  LinkNo = (Select ItemNo from ItemStore Where ItemStoreID=@LinkNo))


		update itemstore
		set 	onorder= (select sum(OrderDeficit) from #MyTemp1),
				DateModified=dbo.GetLocalDATE(),
				UserModified=@ModifierID
		where itemstore.itemstoreid=@LinkNo

	END
GO
SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SP_ItemToGroupDelete]
(@ItemToGroupID uniqueidentifier,
@ModifierID uniqueidentifier)

AS 

Declare @ItemGroupID uniqueidentifier
Declare @ItemStoreID uniqueidentifier

Set @ItemGroupID = (select Top(1) ItemGroupID from ItemToGroup where ItemToGroupID =@ItemToGroupID) 
Set @ItemStoreID = (select Top(1) ItemStoreID from ItemToGroup where ItemToGroupID =@ItemToGroupID) 

UPDATE dbo.ItemToGroup SET	 Status=-1,	DateModified =dbo.GetLocalDATE()
where itemStoreID in(Select ItemStoreID from ItemStore where ItemNo in(
SELECT  ItemStore.ItemNo  FROM ItemStore INNER JOIN
                         ItemToGroup ON ItemStore.ItemStoreID = ItemToGroup.ItemStoreID 
						 where ItemToGroup.ItemToGroupID =@ItemToGroupID  ))
AND ItemGroupID =@ItemGroupID

--delete group for all child items.
declare @itemType int
declare @ItemID uniqueidentifier
set @itemID = (SELECT  ItemStore.ItemNo  FROM ItemStore INNER JOIN
                         ItemToGroup ON ItemStore.ItemStoreID = ItemToGroup.ItemStoreID 
						 where ItemToGroup.ItemToGroupID =@ItemToGroupID)
set @itemType = (select itemtype from ItemMain Where ItemId = @ItemID)

IF @itemType = 2 
Begin
UPDATE dbo.ItemToGroup SET Status=-1,DateModified =dbo.GetLocalDATE()
where itemStoreID in (Select ItemStoreID from ItemStore where ItemNo in (Select ItemID From ItemMain Where LinkNo = @ItemID))
AND ItemGroupID = @ItemGroupID 
End


--NPGS
if @ItemGroupID ='967CE7AC-4366-4F8F-82A6-9694F8701B58'
BEGIN

UPDATE ItemMain SET NoScanMsg =Null , DateModified = dbo.GetLocalDATE()
	FROM ItemStore INNER JOIN
	ItemMain ON ItemStore.ItemNo = ItemMain.ItemID 
	INNER JOIN 	ItemToGroup ON ItemStore.ItemStoreID = ItemToGroup.ItemStoreID
	WHERE (ItemToGroup.ItemGroupID = '967CE7AC-4366-4F8F-82A6-9694F8701B58')
	and ItemMain.NoScanMsg ='THIS ITEM CAN NOT BE SOLD! – "KASHRUS ALERT"' 
	and ItemToGroup.status =-1
	and not exists (
	select 1 
	from ItemToGroup  i 
	where i.ItemStoreID=ItemToGroup.ItemStoreID
	and i.ItemGroupID = '967CE7AC-4366-4F8F-82A6-9694F8701B58'
	and i.status >-1
	)




	UPDATE ItemStore SET DateModified = dbo.GetLocalDATE()
	FROM ItemStore INNER JOIN
	ItemMain ON ItemStore.ItemNo = ItemMain.ItemID 
	INNER JOIN 	ItemToGroup ON ItemStore.ItemStoreID = ItemToGroup.ItemStoreID
	WHERE (ItemToGroup.ItemGroupID = '967CE7AC-4366-4F8F-82A6-9694F8701B58')
	and ItemMain.NoScanMsg ='THIS ITEM CAN NOT BE SOLD! – "KASHRUS ALERT"' 
	and ItemToGroup.status =-1
	and not exists (
	select 1 
	from ItemToGroup  i 
	where i.ItemStoreID=ItemToGroup.ItemStoreID
	and i.ItemGroupID = '967CE7AC-4366-4F8F-82A6-9694F8701B58'
	and i.status >-1
	)




	UPDATE ItemStore Set DateModified =dbo.GetLocalDATE() 
	FROM ItemStore INNER JOIN
	ItemMain ON ItemStore.ItemNo = ItemMain.ItemID INNER JOIN
	ItemToGroup ON ItemStore.ItemStoreID = ItemToGroup.ItemStoreID
	WHERE (ItemToGroup.ItemGroupID = '967CE7AC-4366-4F8F-82A6-9694F8701B58')
	and ItemToGroup.status =-1
	and ItemStore.itemStoreid= @ItemStoreID
END
GO
SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SP_ItemToGroupInsert]
(@ItemToGroupID uniqueidentifier,
@ItemGroupID uniqueidentifier,
@ItemStoreID uniqueidentifier,
@Status smallint,
@ModifierID uniqueidentifier)

AS 
--insert for the selected item.
INSERT INTO dbo.ItemToGroup
                      (ItemToGroupID ,     ItemGroupID ,     ItemStoreID ,   Status,DateModified )					  
VALUES          (@ItemToGroupID , @ItemGroupID , @ItemStoreID , 1,        dbo.GetLocalDATE())

--insert group for all other items.
INSERT INTO ItemToGroup (ItemToGroupID, ItemGroupID, ItemStoreID, Status, DateModified)
select NEWID() , @ItemGroupID , ItemStoreID , 1, dbo.GetLocalDATE() from ItemStore 
where ItemNo in(select Itemno from ItemStore where ItemStoreID =@ItemStoreID )
AND ItemStoreID <>@ItemStoreID

--insert group for all child items.
declare @itemType int
declare @ItemID uniqueidentifier
set @itemID =  (select ItemNo from ItemStore Where ItemStoreID = @ItemStoreID)
set @itemType = (select itemtype from ItemMain Where ItemId = @ItemID)

IF @itemType = 2 
Begin
print 'A'
INSERT INTO ItemToGroup (ItemToGroupID, ItemGroupID, ItemStoreID, Status, DateModified)
select NEWID() , @ItemGroupID , ItemStoreID , 1, dbo.GetLocalDATE() 
FROM ItemStore INNER JOIN ItemMain ON ItemStore.ItemNo = ItemMain.ItemID
where LinkNo = @ItemID
--and ItemStoreID Not In (Select ItemStoreID from ItemToGroup Where ItemGroupID = @ItemGroupID) --make sure the group is not already there.
End


--NPGS
If @ItemGroupID = '967CE7AC-4366-4F8F-82A6-9694F8701B58'
Begin
UPDATE ItemMain SET NoScanMsg ='THIS ITEM CAN NOT BE SOLD! – "KASHRUS ALERT"' , DateModified = dbo.GetLocalDATE()
FROM ItemStore INNER JOIN
ItemMain ON ItemStore.ItemNo = ItemMain.ItemID INNER JOIN
ItemToGroup ON ItemStore.ItemStoreID = ItemToGroup.ItemStoreID
WHERE (ItemToGroup.ItemGroupID = '967CE7AC-4366-4F8F-82A6-9694F8701B58')
and ItemToGroup.status >-1


UPDATE ItemStore Set DateModified =dbo.GetLocalDATE() 
FROM ItemStore INNER JOIN
ItemMain ON ItemStore.ItemNo = ItemMain.ItemID INNER JOIN
ItemToGroup ON ItemStore.ItemStoreID = ItemToGroup.ItemStoreID
WHERE (ItemToGroup.ItemGroupID = '967CE7AC-4366-4F8F-82A6-9694F8701B58')
and ItemToGroup.status >-1
End
GO
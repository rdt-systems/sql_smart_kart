SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SP_ItemToGroupUpdate]
(@ItemToGroupID uniqueidentifier,
@ItemGroupID uniqueidentifier,
@ItemStoreID uniqueidentifier,
@Status smallint,
@DateModified datetime,
@ModifierID uniqueidentifier)

AS 

Declare @UpdateTime datetime
set  @UpdateTime =dbo.GetLocalDATE()

UPDATE dbo.ItemToGroup
SET
	ItemGroupID=@ItemGroupID ,     
	ItemStoreID=@ItemStoreID  ,  
	 Status=@Status,
	DateModified =@UpdateTime
WHERE     (ItemToGroupID = @ItemToGroupID) AND 
      (DateModified = @DateModified OR DateModified IS NULL)

select @UpdateTime as DateModified
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
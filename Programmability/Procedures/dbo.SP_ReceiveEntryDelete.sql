SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SP_ReceiveEntryDelete]

(@ReceiveEntryID uniqueidentifier,
  @ModifierID uniqueidentifier)

AS
declare @ItemStoreID uniqueidentifier
declare @Qty decimal(19,3)


IF (SELECT COUNT(*) FROM ReceiveEntry WHERE  ReceiveEntryID = @ReceiveEntryID)>0 
begin 

  SELECT  TOP(1)@Qty=Qty,@ItemStoreID=ItemStoreNo 
  From [ReceiveEntry]
  where ReceiveEntryID = @ReceiveEntryID


IF (SELECT        ISNULL(ItemMain.ItemType, 0) AS ItemType
FROM            ItemStore INNER JOIN
                         ItemMain ON ItemStore.ItemNo = ItemMain.ItemID
WHERE        (ItemStore.ItemStoreID = @ItemStoreID)) NOT IN (3,5,7,9)     

BEGIN

  UPDATE ItemStore SET OnHand = (OnHand-@Qty),Datemodified=dbo.GetLocalDATE()Where ItemStoreID =@ItemStoreID 
END


UPDATE  dbo.ReceiveEntry              
SET     Status = - 1 ,
	DateModified = dbo.GetLocalDATE(),       
	UserModified = @ModifierID
WHERE  ReceiveEntryID = @ReceiveEntryID
end
GO
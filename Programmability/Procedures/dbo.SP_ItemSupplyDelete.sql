SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SP_ItemSupplyDelete]
(@ItemSupplyID uniqueidentifier,
@ModifierID nvarchar(50))
AS UPDATE    dbo.ItemSupply
SET	Status = -1,
	DateModified = dbo.GetLocalDATE(),
	UserModified = @ModifierID
WHERE	ItemSupplyID = @ItemSupplyID

declare @ItemID uniqueidentifier
declare @SupplierID uniqueidentifier

SELECT      @ItemID=ItemStore.ItemNo,@SupplierID= ItemSupply.SupplierNo
FROM            ItemStore INNER JOIN
                         ItemSupply ON ItemStore.ItemStoreID = ItemSupply.ItemStoreNo
WHERE 	ItemSupplyID=@ItemSupplyID

UPDATE    dbo.ItemSupply
SET	Status = -9,
	DateModified = dbo.GetLocalDATE(),
	UserModified = @ModifierID
WHERE ItemStoreNo in(select ItemStoreID from ItemStore where itemNo=@ItemID) and SupplierNo=@SupplierID And Status >-1
GO
SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SP_PurchaseOrderEntryInsert]
(@PurchaseOrderEntryId uniqueidentifier, 
@PurchaseOrderNo uniqueidentifier, 
@ItemNo uniqueidentifier, 
@QtyOrdered decimal(19, 3), 
@PricePerUnit  money,
@ExtPrice  money,
@UOMQty int,
@UOMType decimal,
@IsSpecialPrice Bit,
@LinkNo uniqueidentifier, 
@Note nvarchar (4000),
@SortOrder int,
@Status Smallint,
@CostBeforeDis money = 0,
@EstimateCost money = 0,
@Discount money = NULL,
@DiscountType int = NULL,
@ModifierID  uniqueidentifier,
@SupplierNo uniqueidentifier = null,
@NetCost  money = 0,
@SpecialCost money = 0
) 
     
AS
INSERT INTO dbo.PurchaseOrderEntry
                      (PurchaseOrderEntryId, PurchaseOrderNo, ItemNo,  QtyOrdered,  PricePerUnit,UOMQty,ExtPrice,  UOMType ,IsSpecialPrice, LinkNo,  Note,SortOrder, Status, DateCreated, UserCreated, DateModified, 
					   CostBeforeDis,EstimateCost, UserModified,NetCost,SpecialCost, Discount, DiscountType)
VALUES     (@PurchaseOrderEntryId, @PurchaseOrderNo, @ItemNo, @QtyOrdered, @PricePerUnit, @UOMQty,@ExtPrice,   @UOMType ,@IsSpecialPrice, @LinkNo, @Note,@SortOrder, 1,dbo.GetLocalDATE(), @ModifierID, 
                      dbo.GetLocalDATE(),@CostBeforeDis, @EstimateCost, @ModifierID,@NetCost,@SpecialCost, @Discount, @DiscountType)

exec UpdateOnOrderByOrder @ItemNo,@ModifierID

--Alex Abreu 6/20/16
--Update the net cost for each item
if @NetCost > 0
Begin
	Update itemstore set Netcost = @NetCost where itemstoreid = @ItemNo
	Update ItemStore Set NetCost = @NetCost Where ItemNo = (Select TOP(1)LinkNo From ChildView Where ItemStoreID = @ItemNo)
End

if @SupplierNo is not  Null and @ItemNo is not null and (select COUNT(1) ItemSupplyID from dbo.ItemSupply where ItemStoreNo = @ItemNo and SupplierNo = @supplierNo AND Status >0)= 0 
begin
insert into dbo.ItemSupply
            (ItemSupplyID,ItemStoreNo,SupplierNo,Status,DateCreated,IsMainSupplier)
values
(newid(),@ItemNo,@SupplierNo,1,dbo.GetLocalDATE(),1)
end
GO
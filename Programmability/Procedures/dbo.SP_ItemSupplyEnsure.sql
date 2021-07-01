SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE Procedure [dbo].[SP_ItemSupplyEnsure]

AS

BEGIN

DECLARE	@ID uniqueidentifier
DECLARE @ItemID uniqueidentifier
Declare @SupplierID uniqueidentifier

Delete From ItemSupply Where Status <0

declare B cursor  for

SELECT    DISTINCT    ItemStoreNo, SupplierNo
FROM            (SELECT        ReceiveEntry.ItemStoreNo, ReceiveOrder.SupplierNo
                          FROM            ReceiveEntry INNER JOIN
                                                    ReceiveOrder ON ReceiveEntry.ReceiveNo = ReceiveOrder.ReceiveID where ReceiveOrder.Status>0 ) AS Receievd
WHERE        (ItemStoreNo NOT IN
                             (SELECT        ItemStoreNo
                               FROM            ItemSupply
                               WHERE        (Status > 0) AND (SupplierNo = Receievd.SupplierNo)))
and ItemStoreNo in(select ItemStoreID from ItemStore)


OPEN B
	fetch next from B into @ItemID,@SupplierID
	while @@fetch_status = 0 begin

	IF @ItemID IS NOT NULL AND @SupplierID IS NOT NULL
	Begin

	set @ID = newID()


EXEC	[dbo].[SP_ItemSupplyInsert]
			@ItemSupplyID = @ID,
			@ItemStoreNo = @ItemID,
			@SupplierNo = @SupplierID,
			@TotalCost = NULL,
			@GrossCost = NULL,
			@MinimumQty = NULL,
			@QtyPerCase = NULL,
			@IsOrderedOnlyInCase = NULL,
			@AverageDeliveryDelay = NULL,
			@ItemCode = NULL,
			@IsMainSupplier = NULL,
			@SortOrder = NULL,
			@Status = 1,
			@ModifierID = null,
			@SaveAsNain = 0

			End

fetch next from B into @ItemID,@SupplierID
	end
	close B
	deallocate B

declare F cursor  for

SELECT    DISTINCT    ItemStoreNo, SupplierNo
FROM            (SELECT       ItemNo AS ItemStoreNo, SupplierNo
                          FROM            PurchaseOrderEntry INNER JOIN
                                                    PurchaseOrders ON PurchaseOrderEntry.PurchaseOrderNo = PurchaseOrders.PurchaseOrderId 
													where PurchaseOrders.Status>0 ) AS Receievd
WHERE        (ItemStoreNo NOT IN
                             (SELECT        ItemStoreNo
                               FROM            ItemSupply
                               WHERE        (Status > 0) AND (SupplierNo = Receievd.SupplierNo)))
and ItemStoreNo in(select ItemStoreID from ItemStore)


OPEN F

	fetch next from F into @ItemID,@SupplierID
	while @@fetch_status = 0 begin

		IF @ItemID IS NOT NULL AND @SupplierID IS NOT NULL
	Begin


	set @ID = newID()


EXEC	[dbo].[SP_ItemSupplyInsert]
			@ItemSupplyID = @ID,
			@ItemStoreNo = @ItemID,
			@SupplierNo = @SupplierID,
			@TotalCost = NULL,
			@GrossCost = NULL,
			@MinimumQty = NULL,
			@QtyPerCase = NULL,
			@IsOrderedOnlyInCase = NULL,
			@AverageDeliveryDelay = NULL,
			@ItemCode = NULL,
			@IsMainSupplier = NULL,
			@SortOrder = NULL,
			@Status = 1,
			@ModifierID = null,
			@SaveAsNain = 0

			End

fetch next from F into @ItemID,@SupplierID
	end
	close F
	deallocate F

END
GO
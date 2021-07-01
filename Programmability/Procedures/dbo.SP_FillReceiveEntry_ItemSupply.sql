SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SP_FillReceiveEntry_ItemSupply]
	@ReceiveNo uniqueidentifier= NULL,
	@PurchaseOrdersNo uniqueidentifier= NULL,
	@SupplierID uniqueidentifier,
	@SaveSupplier int =1

AS
DECLARE	@ID uniqueidentifier
DECLARE @ItemID uniqueidentifier

IF  @ReceiveNo IS NOT NULL BEGIN
	declare B cursor  for

SELECT DISTINCT ChildView.ItemStoreID
FROM            ChildView INNER JOIN
                             (SELECT        ChildView.ItemStoreID, ChildView.LinkNo, ChildView.StoreNo
                               FROM            ChildView INNER JOIN
                                                         ReceiveEntry ON ChildView.ItemStoreID = ReceiveEntry.ItemStoreNo
                               WHERE        (ReceiveEntry.ReceiveNo = @ReceiveNo) AND (ReceiveEntry.Status > 0)) AS AllChilds ON ChildView.LinkNo = AllChilds.LinkNo 
							   --AND ChildView.ItemStoreID <> AllChilds.ItemStoreID
						    --   AND ChildView.StoreNo = AllChilds.StoreNo
  and  ChildView.ItemStoreID not in 	(SELECT ItemStoreNo FROM  ItemSupply WHERE (SupplierNo =@SupplierID) and IsMainSupplier =1 AND (STATUS>0))
		 
	OPEN B

	fetch next from B into @ItemID
	while @@fetch_status = 0 begin

	EXEC	[dbo].[UpdateSupplierItem]
		@ItemStoreID = @ItemID,
		@SupplierID = @SupplierID,
		@MainSupplier = @SaveSupplier,
		@ModifierID = NULL

		fetch next from B into @ItemID
	end
	close B
	deallocate B
END

ELSE IF @PurchaseOrdersNo is NOT NULL BEGIN
	declare F cursor  for
	 

	 SELECT DISTINCT ChildView.ItemStoreID
FROM            ChildView INNER JOIN
                             (SELECT        ChildView.ItemStoreID, ChildView.LinkNo, ChildView.StoreNo
                               FROM            ChildView INNER JOIN
                                                         PurchaseOrderEntry ON ChildView.ItemStoreID = PurchaseOrderEntry.ItemNo 
                               WHERE        (PurchaseOrderEntry.PurchaseOrderNo  = @PurchaseOrdersNo) AND (PurchaseOrderEntry.Status > 0)) AS AllChilds ON ChildView.LinkNo = AllChilds.LinkNo 
							   --AND ChildView.ItemStoreID <> AllChilds.ItemStoreID AND ChildView.StoreNo = AllChilds.StoreNo
and  ChildView.ItemStoreID not in
	(SELECT ItemStoreNo FROM  ItemSupply WHERE (SupplierNo =@SupplierID) AND (STATUS>0))


	OPEN F
	fetch next from F into @ItemID
	while @@fetch_status = 0 begin

	EXEC	[dbo].[UpdateSupplierItem]
		@ItemStoreID = @ItemID,
		@SupplierID = @SupplierID,
		@MainSupplier = @SaveSupplier,
		@ModifierID = NULL

		fetch next from F into @ItemID
	end
	close F
	deallocate F
END


--Update ItemStore Set MainSupplierID = @SupplierID , DateModified =dbo.GetLocalDATE() Where ItemStoreID = @ItemID
GO
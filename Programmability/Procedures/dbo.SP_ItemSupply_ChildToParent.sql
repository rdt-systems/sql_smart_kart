SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SP_ItemSupply_ChildToParent]
AS

BEGIN

Declare @ItemStoreID Uniqueidentifier
Declare @Supplier Uniqueidentifier
Declare @ID Uniqueidentifier
Declare @Main bit

Declare B Cursor For
SELECT        ChildView.ItemStoreID, Parent.SupplierNo
FROM            ChildView INNER JOIN
                             (SELECT DISTINCT ChildView_1.LinkNo, ItemSupply.SupplierNo
                               FROM            ItemSupply INNER JOIN
                                                         ItemStore ON ItemSupply.ItemStoreNo = ItemStore.ItemStoreID AND ItemSupply.ItemSupplyID = ItemStore.MainSupplierID AND ItemSupply.IsMainSupplier = 1 INNER JOIN
                                                         ChildView AS ChildView_1 ON ItemStore.ItemStoreID = ChildView_1.ItemStoreID WHERE ChildView_1.ItemType =2) AS Parent ON ChildView.LinkNo = Parent.LinkNo
Open B

FETCH Next From B Into @ItemStoreID, @Supplier

WHILE @@FETCH_STATUS = 0 Begin

Exec [UpdateSupplierItem]
@ItemStoreID = @ItemStoreID,
@SupplierID = @Supplier,
@MainSupplier = 1,
@ModifierID = '00000000-0000-0000-0000-000000000000'

FETCH Next From B Into @ItemStoreID, @Supplier

END


Close B

Deallocate B


END
GO
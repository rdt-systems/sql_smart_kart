SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE VIEW [dbo].[PhoneOrderEntryView]
AS
SELECT        TOP (100) PERCENT PhoneOrderEntry.PhoneOrderEntryID, PhoneOrderEntry.PhoneOrderID, PhoneOrderEntry.ItemStoreNo, PhoneOrderEntry.Qty, PhoneOrderEntry.UOMQty, PhoneOrderEntry.UOMType, 
                         PhoneOrderEntry.UOMPrice, PhoneOrderEntry.ExtPrice, PhoneOrderEntry.LinkNo, PhoneOrderEntry.Note, PhoneOrderEntry.SortOrder, PhoneOrderEntry.Status, PhoneOrderEntry.DateCreated, 
                         PhoneOrderEntry.UserCreated, PhoneOrderEntry.DateModified, PhoneOrderEntry.UserModified, ItemMainAndStoreView.Name, ItemMainAndStoreView.ModalNumber AS ModalNo, ItemMainAndStoreView.BarcodeNumber AS BarCode, 
                         ItemMainAndStoreView.OnHand , ItemMainAndStoreView.Department, ItemMainAndStoreView.SupplierName AS Supplier,
						 case when PhoneOrderEntry.UOMType=2 
							  then  isnull(ItemMainAndStoreView.[Cs Cost],0)*isnull(PhoneOrderEntry.Qty,0) 
							  else isnull(ItemMainAndStoreView.[PC Cost],0)*isnull(PhoneOrderEntry.Qty,0) end 
							 as Cost
FROM            PhoneOrderEntry INNER JOIN ItemMainAndStoreView ON PhoneOrderEntry.ItemStoreNo = ItemMainAndStoreView.ItemStoreID 
WHERE        (PhoneOrderEntry.Status > -1)
ORDER BY PhoneOrderEntry.SortOrder
GO
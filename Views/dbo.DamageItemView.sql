SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO





CREATE VIEW [dbo].[DamageItemView]
AS
SELECT        DamageItem.DamageItemID, DamageItem.ItemStoreID, DamageItem.Qty, DamageItem.DamageStatus, DamageItem.TransactionEntryID, DamageItem.ReturnEntryID, DamageItem.Date, DamageItem.Status, 
                         DamageItem.DateCreated, DamageItem.UserCreated, DamageItem.DateModified, DamageItem.UserModified, [Transaction].TransactionID, [Transaction].TransactionNo, ItemMain.Name, ItemMain.ModalNumber, 
                         ItemMain.BarcodeNumber, Supplier.Name AS SupplierName, Supplier.SupplierID
FROM            DamageItem INNER JOIN
                         [Transaction] ON [Transaction].TransactionID =
                             (SELECT        TransactionID
                               FROM            TransactionEntry
                               WHERE        (TransactionEntryID = DamageItem.TransactionEntryID)) AND [Transaction].Status <> 0 INNER JOIN
                         ItemStore ON DamageItem.ItemStoreID = ItemStore.ItemStoreID INNER JOIN
                         ItemMain ON ItemStore.ItemNo = ItemMain.ItemID LEFT OUTER JOIN
                         ItemSupply AS ItemSupply_1 ON ItemStore.MainSupplierID = ItemSupply_1.ItemSupplyID LEFT OUTER JOIN
                         Supplier ON ItemSupply_1.SupplierNo = Supplier.SupplierID
GO
SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE VIEW [dbo].[StoreInventory]
AS
SELECT       Store.StoreNumber+ ItemMain.BarcodeNumber as ID, ItemMain.BarcodeNumber As UPC, ItemStore.OnHand, Store.StoreNumber,ItemStore.Status, ItemStore.DateModified,Store.StoreID
FROM            ItemStore INNER JOIN
                         Store ON ItemStore.StoreNo = Store.StoreID INNER JOIN
                         ItemMain ON ItemStore.ItemNo = ItemMain.ItemID
WHERE        (ItemStore.Status > 0) AND (Store.Status > 0)
GO
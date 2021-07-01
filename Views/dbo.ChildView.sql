SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO






CREATE VIEW [dbo].[ChildView]
AS
SELECT        ItemMain.ItemID, ISNULL(ItemMain.LinkNo,ItemMain.ItemID) AS LinkNo, ItemStore.ItemStoreID, ItemMain.Matrix1 AS Color, ItemMain.Matrix2 AS Size, ItemStore.StoreNo,ItemType, ItemStore.OnHand
FROM            ItemStore INNER JOIN
                         ItemMain ON ItemStore.ItemNo = ItemMain.ItemID
GO
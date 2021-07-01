SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE VIEW [dbo].[WebItemsInventory]

AS
Select W.ItemStoreID, W.SKU, W.OnHand, O.OtherStores From (
Select M.ItemID, S.ItemStoreID, M.BarcodeNumber AS SKU, ISNULL(S.OnHand,0) AS OnHand from ItemMain M INNER JOIN ItemStore S ON M.ItemID = S.ItemNo
Where M.Status > 0 and S.Status > 0 AND S.StoreNo = '46C8541B-33D4-4A73-AA82-9520DF098D44') AS W INNER JOIN (
Select M.ItemID, M.BarcodeNumber AS SKU, SUM(ISNULL(S.OnHand,0)) AS OtherStores from ItemMain M INNER JOIN ItemStore S ON M.ItemID = S.ItemNo
Where M.Status > 0 and S.Status > 0 AND S.StoreNo <> '46C8541B-33D4-4A73-AA82-9520DF098D44'
GROUP BY M.ItemID, M.BarcodeNumber) AS O ON W.ItemID = O.ItemID


GO
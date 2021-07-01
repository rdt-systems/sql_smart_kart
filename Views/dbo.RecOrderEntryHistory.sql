SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE VIEW [dbo].[RecOrderEntryHistory]
AS
SELECT     dbo.ReceiveEntry.ReceiveEntryID AS ReceiveOrderEntryID, dbo.ReceiveEntry.ReceiveNo AS ReceiveOrderID, dbo.ReceiveEntry.ItemStoreNo AS ItemNo, 
                      dbo.ReceiveEntry.UOMQty AS QtyOrdered, dbo.ReceiveEntry.UOMType, dbo.ItemMain.Name AS ItemName, dbo.ReceiveEntry.Cost AS UOMPrice, 
                      dbo.ItemMain.BarcodeNumber AS BarCode, dbo.ReceiveEntry.SortOrder, dbo.ReceiveEntry.CaseQty AS csQty
FROM         dbo.ItemStore INNER JOIN
                      dbo.ReceiveEntry ON dbo.ItemStore.ItemStoreID = dbo.ReceiveEntry.ItemStoreNo INNER JOIN
                      dbo.ItemMain ON dbo.ItemStore.ItemNo = dbo.ItemMain.ItemID
WHERE     (dbo.ReceiveEntry.Status > - 1)
GO
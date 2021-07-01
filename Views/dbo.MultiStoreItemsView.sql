SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE VIEW [dbo].[MultiStoreItemsView]
AS
SELECT     dbo.ItemMain.Name, dbo.ItemMain.BarcodeNumber, dbo.ItemMain.ModalNumber, dbo.Store.StoreName, dbo.ItemStore.Price, ISNULL(dbo.ItemStore.OnHand, 0) 
                      AS OnHand, ISNULL(dbo.ItemStore.OnOrder, 0) AS OnOrder, dbo.DepartmentStore.Name AS Department, dbo.ItemMain.ItemID, ISNULL(dbo.ItemStore.OnTransferOrder, 
                      0) AS OnTransferOrder
FROM         dbo.ItemMain INNER JOIN
                      dbo.ItemStore ON dbo.ItemMain.ItemID = dbo.ItemStore.ItemNo INNER JOIN
                      dbo.Store ON dbo.ItemStore.StoreNo = dbo.Store.StoreID LEFT OUTER JOIN
                      dbo.DepartmentStore ON dbo.ItemStore.DepartmentID = dbo.DepartmentStore.DepartmentStoreID
WHERE     (dbo.ItemMain.Status > - 1) AND (dbo.ItemStore.Status > - 1) AND (dbo.ItemMain.ItemType <> 2)
GO
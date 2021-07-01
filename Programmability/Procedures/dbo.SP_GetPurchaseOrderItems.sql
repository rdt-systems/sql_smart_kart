SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SP_GetPurchaseOrderItems]
(@ItemNo uniqueidentifier)
AS SELECT     dbo.ItemMain.Name, dbo.ItemMain.Description, dbo.PurchaseOrderEntry.QtyOrdered, dbo.PurchaseOrderEntry.DateCreated
FROM         dbo.ItemStore INNER JOIN
                      dbo.ItemMain ON dbo.ItemStore.ItemNo = dbo.ItemMain.ItemID INNER JOIN
                      dbo.PurchaseOrderEntry ON dbo.ItemStore.ItemStoreID = dbo.PurchaseOrderEntry.ItemNo
Where  dbo.PurchaseOrderEntry.ItemNo =@ItemNo
GO
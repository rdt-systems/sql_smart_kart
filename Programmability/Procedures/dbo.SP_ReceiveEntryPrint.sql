SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SP_ReceiveEntryPrint](@ID uniqueidentifier)
AS SELECT     dbo.ReceiveEntryView.ReceiveNo, dbo.ReceiveEntryView.UOMQty, dbo.SysUOMTypeView.SystemValueName AS UOM, 
                      dbo.ReceiveEntryView.UOMPrice, dbo.ItemMainAndStoreView.Name, dbo.ItemMainAndStoreView.BarcodeNumber, 
                      dbo.ItemMainAndStoreView.ModalNumber, dbo.ReceiveEntryView.UOMPrice * dbo.ReceiveEntryView.UOMQty AS TotalPrice
FROM         dbo.ReceiveEntryView INNER JOIN
                      dbo.SysUOMTypeView ON dbo.ReceiveEntryView.UOMType = dbo.SysUOMTypeView.SystemValueNo INNER JOIN
                      dbo.ItemMainAndStoreView ON dbo.ReceiveEntryView.ItemStoreNo = dbo.ItemMainAndStoreView.ItemStoreID
WHERE     (dbo.ReceiveEntryView.ReceiveNo = @ID) AND (dbo.ItemMainAndStoreView.ItemType <> 2)--matrix
GO
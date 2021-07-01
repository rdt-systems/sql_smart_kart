SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SP_GetTransferStoreEntry](@StartDate datetime,
@EndDate datetime,
@StoreID uniqueidentifier=null)
AS
SELECT     dbo.TransferEntry.Qty, dbo.ItemMainAndStoreView.Name,dbo.TransferEntry.TransferID, dbo.ItemMainAndStoreView.BarcodeNumber, dbo.ItemMainAndStoreView.ModalNumber

FROM         dbo.TransferEntry INNER JOIN
                      dbo.TransferItems ON dbo.TransferEntry.TransferID = dbo.TransferItems.TransferID INNER JOIN
                      dbo.ItemMainAndStoreView ON dbo.TransferEntry.ItemStoreNo = dbo.ItemMainAndStoreView.ItemID And dbo.ItemMainAndStoreView.StoreNo=dbo.TransferItems.FromStoreID
WHERE     (dbo.TransferItems.TransferDate >= @StartDate) AND (dbo.TransferItems.TransferDate < @EndDate) AND (dbo.TransferItems.Status > 0) AND 
          (dbo.TransferItems.FromStoreID = @StoreID OR @StoreID IS NULL) AND (dbo.TransferEntry.Status>0)
GO
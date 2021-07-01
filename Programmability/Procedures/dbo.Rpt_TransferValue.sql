SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[Rpt_TransferValue] 
(@StoreID uniqueidentifier = null, @FromDate datetime, @ToDate datetime)
as

SELECT        ItemMainAndStoreView.Name, ItemMainAndStoreView.BarcodeNumber, ItemMainAndStoreView.ModalNumber AS ModelNumber, ISNULL(ReceiveTransferEntry.Qty, 0) AS ReceiveQty, TransferEntry.Qty AS ShipQty, 
                         TransferEntry.Qty - ISNULL(ReceiveTransferEntry.Qty, 0) AS OnTransaferQty, ItemMainAndStoreView.[Pc Cost] * (TransferEntry.Qty - ISNULL(ReceiveTransferEntry.Qty, 0)) AS TransferCost, 
                         ItemMainAndStoreView.Price * (TransferEntry.Qty - ISNULL(ReceiveTransferEntry.Qty, 0)) AS TransferRetailValue, TransferItemsView.[From Store], TransferItemsView.[To Store], 
                         TransferItemsView.TransferStatusDec AS TransferStatus, TransferItemsView.TransferNo, TransferEntry.ItemStoreNo, TransferEntry.TransferEntryID
FROM            ReceiveTransferEntry RIGHT OUTER JOIN
                         TransferItemsView INNER JOIN
                         TransferEntry ON TransferItemsView.TransferID = TransferEntry.TransferID INNER JOIN
                         ItemMainAndStoreView ON TransferEntry.ItemStoreNo = ItemMainAndStoreView.ItemStoreID ON ReceiveTransferEntry.TransferEntryID = TransferEntry.TransferEntryID
WHERE        (((TransferEntry.Qty - ISNULL(ReceiveTransferEntry.Qty, 0) > 0)  AND (TransferItemsView.ToStoreID = @StoreID)) 
                        OR ((TransferEntry.Qty - ISNULL(ReceiveTransferEntry.Qty, 0) > 0)  AND (@StoreID IS NULL)))
						 AND (TransferEntry.DateCreated >= @FromDate AND TransferEntry.DateCreated <= @ToDate)
GO
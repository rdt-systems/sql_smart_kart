SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[Rpt_TransferItems]
(
@Filter nvarchar(4000) =''
)
as

declare @MySelect nvarchar(2000)
set @MySelect='SELECT  TransferEntry.Qty AS ShipQty, ItemMainAndStoreView.Name, Cast(ItemMainAndStoreView.[Pc Cost] AS Money) AS PcCost, CAST(ItemMainAndStoreView.Price AS Money) As Price, ItemMainAndStoreView.ModalNumber AS ModelNumber, ItemMainAndStoreView.BarcodeNumber, 
                TransferItemsView.[From Store], TransferItemsView.[To Store], TransferItemsView.TransferDate, TransferItemsView.TransferStatusDec, 
                         TransferItemsView.UserName AS TransferBy, ISNULL(Receive.ReceiveQty, 0) AS ReceiveQty, CAST(ISNULL(ItemMainAndStoreView.AVGCost * TransferEntry.Qty, 0) AS Money) 
                         AS ExtCost, CAST(ISNULL(ItemMainAndStoreView.Price * TransferEntry.Qty, 0) AS Money) AS ExtPrice,  TransferItemsView.TransferNo, TransferEntry.ItemStoreNo, TransferEntry.TransferEntryID
FROM            TransferEntry INNER JOIN
                         ItemMainAndStoreView ON TransferEntry.ItemStoreNo = ItemMainAndStoreView.ItemStoreID INNER JOIN
                         TransferItemsView ON TransferEntry.TransferID = TransferItemsView.TransferID LEFT OUTER JOIN
                             (SELECT        SUM(Qty) AS ReceiveQty, TransferEntryID
                               FROM            ReceiveTransferEntry
                               GROUP BY TransferEntryID) AS Receive ON TransferEntry.TransferEntryID = Receive.TransferEntryID
WHERE        (TransferItemsView.Status > 0)'
 


print (@MySelect +@Filter)

exec(@MySelect +@Filter )
GO
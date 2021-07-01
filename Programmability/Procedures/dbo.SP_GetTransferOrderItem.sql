SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SP_GetTransferOrderItem]
(@ItemID uniqueidentifier,
@ShowClose int,
@StoreID uniqueidentifier,
 @Stores Guid_list_tbltype READONLY)
AS

Declare @TrStatus int

IF @ShowClose = 0 Set @TrStatus = 1
IF @ShowClose = 1 Set @TrStatus = 3 

 IF not EXISTS ( Select 1 from @Stores) 

 begin 

SELECT        TransferItemsView.TransferID AS TransferOrderID, TransferItemsView.TransferDate AS TransferOrderDate, TransferItemsView.TransferNo AS TransferOrderNo, SUM(ISNULL(TransferEntryView.Qty, 0)) AS Qty, 
                         TransferItemsView.[From Store] AS Store
FROM            TransferItemsView INNER JOIN
                         TransferEntryView ON TransferItemsView.TransferID = TransferEntryView.TransferID
WHERE        (TransferItemsView.ToStoreID = @StoreID) 
AND (TransferEntryView.ItemStoreNo IN (SELECT        ItemStoreID
										   FROM            ItemStore
										   WHERE        (ItemNo = @ItemID)))
							    AND (TransferItemsView.Status > 0) AND (TransferEntryView.Status > 0) AND (TransferItemsView.TransferStatus <= @TrStatus)
GROUP BY TransferItemsView.TransferID, TransferItemsView.TransferDate, TransferItemsView.TransferNo, TransferItemsView.[From Store]

end 

else 

begin 



SELECT        TransferItemsView.TransferID AS TransferOrderID, TransferItemsView.TransferDate AS TransferOrderDate, TransferItemsView.TransferNo AS TransferOrderNo, SUM(ISNULL(TransferEntryView.Qty, 0)) AS Qty, 
                         TransferItemsView.[From Store] AS Store
FROM            TransferItemsView INNER JOIN
                         TransferEntryView ON TransferItemsView.TransferID = TransferEntryView.TransferID
WHERE       1=1
AND  TransferItemsView.ToStoreID in (select n from  @Stores)
AND (TransferEntryView.ItemStoreNo IN (SELECT        ItemStoreID
										   FROM            ItemStore
										   WHERE        (ItemNo = @ItemID)))
							    AND (TransferItemsView.Status > 0) AND (TransferEntryView.Status > 0) AND (TransferItemsView.TransferStatus <= @TrStatus)
GROUP BY TransferItemsView.TransferID, TransferItemsView.TransferDate, TransferItemsView.TransferNo, TransferItemsView.[From Store]

end
GO
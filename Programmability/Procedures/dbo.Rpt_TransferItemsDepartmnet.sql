SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO



CREATE PROCEDURE [dbo].[Rpt_TransferItemsDepartmnet]
(
@Filter nvarchar(4000) ='',
@SubDepartment1Caption nvarchar(4000) ='',
@SubDepartment2Caption nvarchar(4000) =''
)
as

declare @MySelect nvarchar(2000)
declare @MyGroup nvarchar(2000)
set @MySelect='SELECT
    TransferItemsView.[From Store],
  TransferItemsView.[To Store],
    ItemMainAndStoreView.MainDepartment,
  ItemMainAndStoreView.SubDepartment '+@SubDepartment1Caption+',
  ItemMainAndStoreView.SubSubDepartment '+@SubDepartment2Caption+',
  sum(TransferEntry.Qty) AS TransferQty,
  sum(ISNULL(Receive.ReceiveQty, 0)) AS ReceiveQty,
  sum(CAST(ISNULL(ItemMainAndStoreView.AVGCost * TransferEntry.Qty, 0) AS money))  AS ExtCost,
  sum(CAST(ISNULL(ItemMainAndStoreView.Price * TransferEntry.Qty, 0) AS money)) AS ExtPrice,
  sum(CAST(ISNULL(ItemMainAndStoreView.AVGCost * ISNULL(Receive.ReceiveQty, 0), 0) AS money))  AS ReceiveExtCost,
  sum(CAST(ISNULL(ItemMainAndStoreView.Price * ISNULL(Receive.ReceiveQty, 0), 0) AS money)) AS ReceiveExtPrice
FROM TransferEntry
INNER JOIN ItemMainAndStoreView
  ON TransferEntry.ItemStoreNo = ItemMainAndStoreView.ItemStoreID
INNER JOIN TransferItemsView
  ON TransferEntry.TransferID = TransferItemsView.TransferID
LEFT OUTER JOIN (SELECT
  SUM(Qty) AS ReceiveQty,
  TransferEntryID
FROM ReceiveTransferEntry
GROUP BY TransferEntryID) AS Receive
  ON TransferEntry.TransferEntryID = Receive.TransferEntryID
WHERE (TransferItemsView.Status > 0) '
 

 set @MyGroup =' group by      TransferItemsView.[From Store],
  TransferItemsView.[To Store],
  ItemMainAndStoreView.MainDepartment,
  ItemMainAndStoreView.SubDepartment,
  ItemMainAndStoreView.SubSubDepartment' 

print (@MySelect +@Filter+@MyGroup)

exec(@MySelect +@Filter +@MyGroup)
GO
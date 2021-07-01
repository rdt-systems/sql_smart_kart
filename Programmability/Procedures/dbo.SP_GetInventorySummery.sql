SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SP_GetInventorySummery]
(@Filter nvarchar(4000),
@FromDate DateTime ='01/01/1900',
@ToDate DateTime = '12/31/2999')

as
declare @MySelect nvarchar(max)
declare @MySelect2 nvarchar(max)
declare @GroupBy nvarchar(4000)


set @MySelect= 'select Allitems.*,
Allitems.TotalInventory-Allitems.onhand as DifOnHand,
Allitems.TotalCost-Allitems.OnHandCost as DifOnHandCost
from (
select Supplier.SupplierNo ,
Supplier.Name  as SupplierName,
store.StoreNumber,
sum(isnull(ReceiveEntry.qty,0)) as ReceiveQty,
sum(isnull(TransferEntry.qty,0))+sum(isnull(ReceiveTransferEntry.qty,0)) as TransferQty,
sum(isnull(ReturntovenderEntry.qty,0)) as ReturntQty,
sum(isnull(AdjustInventory.qty,0)) as AdjustQty,
sum(isnull(SeasonHistory.Onhand,0)) as SeasonHistoryOnhand,
sum(isnull(TransactionEntry.qty,0)) as TransactionEntryQty,
TotalInventory= sum(isnull(ReceiveEntry.qty,0))
+sum(isnull(TransferEntry.qty,0))
+sum(isnull(ReceiveTransferEntry.qty,0)) 
+sum(isnull(ReturntovenderEntry.qty,0))
+sum(isnull(AdjustInventory.qty,0))
+sum(isnull(SeasonHistory.Onhand,0))
+sum(isnull(TransactionEntry.qty,0)) ,
sum(isnull(itemstore.OnHand ,0))  AS OnHand,
sum(isnull(ReceiveEntry.Cost,0)) as ReceiveCost,
sum(isnull(TransferEntry.Cost,0))+sum(isnull(ReceiveTransferEntry.Cost,0)) as TransferCost,
sum(isnull(ReturntovenderEntry.Cost,0)) as ReturntCost,
sum(isnull(AdjustInventory.Cost,0)) as AdjustCost,
sum(isnull(SeasonHistory.Cost,0)) as SeasonHistoryOnhandCost,
sum(isnull(TransactionEntry.Cost,0)) as TransactionEntryCost,
TotalCost=sum(isnull(ReceiveEntry.Cost,0)) +
sum(isnull(TransferEntry.Cost,0))+sum(isnull(ReceiveTransferEntry.Cost,0)) +
sum(isnull(ReturntovenderEntry.Cost,0))+
sum(isnull(AdjustInventory.Cost,0))+
sum(isnull(SeasonHistory.Cost,0)) +
sum(isnull(TransactionEntry.Cost,0)) ,
sum(isnull(itemstore.OnHand ,0)* isnull(itemstore.Cost,0)) AS OnHandCost
from itemmain join itemstore on itemmain.itemid =itemstore.ItemNo 
join store on store.StoreID =itemstore.StoreNo
left outer join ItemSupply on ItemSupply.ItemStoreNo=itemstore.ItemStoreID and  ItemSupply.IsMainSupplier =1
left outer join Supplier on Supplier.SupplierID=ItemSupply.SupplierNo
left outer join
(select ReceiveEntry.ItemStoreNo ,sum(qty)as qty,sum(Cost)as Cost
from ReceiveEntry  
where DateCreated >= '''+ CONVERT(nvarchar(10),@FromDate,120)+'''
and DateCreated <= '''+CONVERT(nvarchar(10),@ToDate,120)+'''
group by ReceiveEntry.ItemStoreNo) as ReceiveEntry
on ReceiveEntry.ItemStoreNo=itemstore.ItemStoreID
left outer join
(select AdjustInventory.ItemStoreNo ,sum(qty)as qty,sum(Cost)as Cost
from AdjustInventory  
where DateCreated >= '''+ CONVERT(nvarchar(10),@FromDate,120)+'''
and DateCreated <= '''+CONVERT(nvarchar(10),@ToDate,120)+'''
group by AdjustInventory.ItemStoreNo) as AdjustInventory
on AdjustInventory.ItemStoreNo=itemstore.ItemStoreID
left outer join
(select TransferEntry.ItemStoreNo ,sum(qty)as qty,sum(Cost)as Cost
from TransferEntry  
where DateCreated >= '''+ CONVERT(nvarchar(10),@FromDate,120)+'''
and DateCreated <= '''+CONVERT(nvarchar(10),@ToDate,120)+'''
group by TransferEntry.ItemStoreNo) as TransferEntry
on TransferEntry.ItemStoreNo=itemstore.ItemStoreID
left outer join
(select ReceiveTransferEntry.ItemStoreID ,sum(qty)as qty,sum(Cost)as Cost
from ReceiveTransferEntry  
where DateCreate >= '''+ CONVERT(nvarchar(10),@FromDate,120)+'''
and DateCreate <= '''+CONVERT(nvarchar(10),@ToDate,120)+'''
group by ReceiveTransferEntry.ItemStoreID) as ReceiveTransferEntry
on ReceiveTransferEntry.ItemStoreID=itemstore.ItemStoreID
left outer join
(select ReturntovenderEntry.ItemStoreNo ,sum(qty)as qty,sum(Cost)as Cost
from ReturntovenderEntry  
where DateCreated >= '''+ CONVERT(nvarchar(10),@FromDate,120)+'''
and DateCreated <= '''+CONVERT(nvarchar(10),@ToDate,120)+'''
group by ReturntovenderEntry.ItemStoreNo) as ReturntovenderEntry
on ReturntovenderEntry.ItemStoreNo=itemstore.ItemStoreID
left outer join
(select TransactionEntry.ItemStoreID ,sum(qty)as qty,sum(Cost)as Cost
from TransactionEntry  
where DateCreated >= '''+ CONVERT(nvarchar(10),@FromDate,120)+'''
and DateCreated <= '''+CONVERT(nvarchar(10),@ToDate,120)+'''
group by TransactionEntry.ItemStoreID) as TransactionEntry
on TransactionEntry.ItemStoreID=itemstore.ItemStoreID

'
set @MySelect2= 'left outer join
(select  ROW_NUMBER() OVER(PARTITION BY itemstoreid ,NewSeasonId ORDER BY DateCreated DESC) AS RowNumber,SeasonHistory.ItemStoreId,SeasonHistory.Onhand,(SeasonHistory.Onhand * Cost)as Cost 
from SeasonHistory 
where DateCreated >= '''+ CONVERT(nvarchar(10),@FromDate,120)+'''
and DateCreated <= '''+CONVERT(nvarchar(10),@ToDate,120)+'''
)as SeasonHistory
on SeasonHistory.ItemStoreID=itemstore.ItemStoreID and  SeasonHistory.RowNumber=1
where 1=1'

set @GroupBy ='  
group by  Supplier.SupplierNo ,
Supplier.Name ,
store.StoreNumber)as Allitems'
print (@MySelect )
print (@MySelect2+ @Filter + @GroupBy)
Execute (@MySelect+@MySelect2 + @Filter + @GroupBy)
GO
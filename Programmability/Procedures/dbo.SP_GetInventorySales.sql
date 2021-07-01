SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SP_GetInventorySales]
(@Filter nvarchar(4000),
@FilterDate nvarchar(4000))

as
declare @MySelect nvarchar(4000)
declare @MySelect2 nvarchar(4000)
declare @GroupBy nvarchar(4000)


set @MySelect= 'select Supplier.SupplierNo, 
Supplier.Name as SupplierName ,
store.StoreNumber,
sum(isnull(ReceiveEntry.Qty,0)) as ReceiveEntryQty,
sum(isnull(TransactionEntry.qty,0)) as TransactionEntryQty,
sum(itemstore.OnHand) as OnHand ,
sum(ReceiveEntry.NetCost)as NetCost,
sum(isnull(TransferEntry.qty,0)) as TransferEntryQty ,
sum(TransactionEntry.Total) as TransactionEntryTotal,
sum(TransactionEntry.profit) as Profit,
sum(itemstore.OnHand*isnull(AVGCost,0)) as OnHandAvgCost,
avg(TransactionEntry.DiscountPerc) as DiscountPerc ,
avg(case when itemstore.ListPrice <> 0 then  (1 - itemstore.Price /   itemstore.ListPrice ) * 100  else 0 end ) as MarkDown,
avg(TransactionEntry.profit) as ProfitPerc,
avg(TransactionEntry.InventorySold)as InventorySold
from itemmain  
join itemstore on  itemmain.itemid =itemstore.itemno
join store on  store.StoreID =itemstore.StoreNo
left outer join ItemSupply  on  ItemSupply.ItemStoreNo =itemstore.ItemStoreID and ItemSupply.IsMainSupplier=1
 left outer join Supplier  on  Supplier.SupplierID =ItemSupply.SupplierNo
 left outer join (select ItemStoreNo ,  sum(ReceiveEntry.Qty) as Qty ,sum(NetCost) as NetCost from ReceiveEntry group by ItemStoreNo) as  ReceiveEntry   on  ReceiveEntry.ItemStoreNo =itemstore.ItemStoreID
 left outer  join (select TransactionEntry.ItemStoreID ,sum(TransactionEntry.Qty) as qty  ,sum(TransactionEntry.Total) as Total,
   sum(ISNULL(TransactionEntry.TotalAfterDiscount,TransactionEntry.Total) - ISNULL(TransactionEntry.AVGCost, 0) ) as profit,
    sum( ISNULL(TransactionEntry.AVGCost, 0) /ISNULL(TransactionEntry.TotalAfterDiscount,TransactionEntry.Total)  ) as profitPerc,
   avg(isnull(TransactionEntry.DiscountPerc,0)) as DiscountPerc,
		sum(CASE WHEN (IsNull(FnGetItemOnHand.Qty, 0) > 0 AND ISNULL((TransactionEntry.QTY), 
                         0) > 0) THEN ((100/(FnGetItemOnHand.Qty + (TransactionEntry.QTY))*(TransactionEntry.QTY)) / 100) ELSE 0 END) AS InventorySold
   from TransactionEntry  LEFT OUTER hash JOIN
                         dbo.FnGetItemOnhand(dbo.GetLocalDATE()) AS FnGetItemOnhand ON TransactionEntry.ItemStoreID = FnGetItemOnhand.ItemStoreID '

 set @MySelect2 ='group by TransactionEntry.ItemStoreID) as  TransactionEntry 
  on  TransactionEntry.ItemStoreID =itemstore.ItemStoreID
    left outer   join (select ItemStoreNo ,sum(isnull(TransferEntry.Qty,0)) as qty  
   from TransferEntry group by ItemStoreNo) as  TransferEntry 
  on  TransferEntry.ItemStoreNo =itemstore.ItemStoreID
   where 1=1 

'

set @GroupBy ='  group by  Supplier.SupplierNo, 
Supplier.Name,
  store.StoreNumber'

  print  (@MySelect +@FilterDate+@MySelect2+ @Filter + @GroupBy)
Execute (@MySelect +@FilterDate+@MySelect2+ @Filter + @GroupBy)
GO
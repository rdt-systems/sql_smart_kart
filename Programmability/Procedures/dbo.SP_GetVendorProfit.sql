SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SP_GetVendorProfit]
(@Filter nvarchar(4000) ='',

@FromDate DateTime ='01/01/1900',
@ToDate DateTime = '12/31/2999'

)
as
declare @MySelect varchar(8000)

declare @GroupBy varchar(8000)


set @MySelect= ' select StoreNo,storeName, Department,DepartmentID,SupplierName,SeasonName,
sum(isnull(Purchase.qty,0)) as UnitsOrder,
sum(isnull(Receive.qty,0)) as UnitsReceive,
sum(isnull(Receive.qty,0)*cost) as CostReceive,
sum(isnull(Receive.qty,0)*price) as RetailRecive ,
sum(isnull(Transfer.qty,0)) as UnitsTransfer,
sum(isnull(Transfer.qty,0)*cost) as CostTransfer,
sum(isnull(Transfer.qty,0)*price) as RetailTransfer ,
sum(isnull(TransferReceive.qty,0)) as UnitsTransferReceiver,
sum(isnull(TransferReceive.qty,0)*cost) as CostTransferReceive,
sum(isnull(TransferReceive.qty,0)*price) as RetailTransferReceive ,
sum(isnull(Adjust.qty,0)) as UnitsAdjust,
sum(isnull(Adjust.qty,0)*cost) as CostAdjust,
sum(isnull(Adjust.qty,0)*price) as RetailAdjust ,
sum(isnull(Receive.qty,0)) +
sum(isnull(Transfer.qty,0)) +
sum(isnull(TransferReceive.qty,0)) +
sum(isnull(Adjust.qty,0)) as SumQty,
sum(Isnull(Receive.qty*cost,0)) + 
sum(Isnull(Transfer.qty*cost,0)) + 
sum(Isnull(TransferReceive.qty*cost,0)) + 
sum(Isnull(Adjust.qty*cost,0))  as SumCostReceive,
sum(isnull(Receive.qty*price,0)) + 
sum(isnull(Transfer.qty*price,0)) +
sum(isnull(TransferReceive.qty*price,0)) +
sum(isnull(Adjust.qty*price,0)) as SumRetail ,
sum(isnull(onHand,0))as onHand,
sum(isnull(onHand,0)*Cost) as onHandCost,
sum(isnull(Trans.qty,0))as UnitsSold,
sum(isnull(Trans.total,0))as TotalSales,
avg(isnull(Trans.total,0)-isnull(Trans.TransCost,0)/iif(isnull(Trans.TransCost,0)=0,1,Trans.TransCost)) as Markup,
sum(isnull(Trans.total,0)-isnull(Trans.TransCost,0)) as Profit
from itemMainAndStoreView left  join (select ItemStoreNo,sum(qty)as qty
from ReceiveEntry join ReceiveOrder on ReceiveEntry.ReceiveNo=ReceiveOrder.ReceiveID
where ReceiveEntry.status>0 and ReceiveOrder.status>0
and ReceiveEntry.DateCreated >= '''+ CONVERT(nvarchar(10),@FromDate,120)+'''
and ReceiveEntry.DateCreated <= '''+CONVERT(nvarchar(10),@ToDate,120)+'''
group by ItemStoreNo) Receive on Receive.ItemStoreNo=itemMainAndStoreView.itemstoreid
 left join  (select ItemNo,sum(QtyOrdered)as qty
from PurchaseOrderEntry join PurchaseOrders on PurchaseOrderEntry.PurchaseOrderNo=PurchaseOrders.PurchaseOrderId
where PurchaseOrderEntry.status>0
and PurchaseOrders.status>0
and PurchaseOrderEntry.DateCreated >= '''+ CONVERT(nvarchar(10),@FromDate,120)+'''
and PurchaseOrderEntry.DateCreated <= '''+CONVERT(nvarchar(10),@ToDate,120)+'''
group by ItemNo) Purchase on Purchase.ItemNo=itemMainAndStoreView.itemstoreid
  left join  (select  ItemStoreID,sum(qty)as qty,sum(totalAfterDiscount)as total,sum(cost*qty)as TransCost
from TransactionEntry join [Transaction] on TransactionEntry.TransactionID=[Transaction].TransactionID
where TransactionEntry.status>0
and [Transaction].status>0
and TransactionEntry.DateCreated >= '''+ CONVERT(nvarchar(10),@FromDate,120)+'''
and TransactionEntry.DateCreated <= '''+CONVERT(nvarchar(10),@ToDate,120)+'''
group by ItemStoreID) Trans on Trans.ItemStoreID=itemMainAndStoreView.itemstoreid
  left  join (select ItemStoreNo,sum(qty) as qty
from TransferEntry join TransferItems on TransferEntry.TransferID=TransferItems.TransferID
where 1=1
and TransferEntry.DateCreated >= '''+ CONVERT(nvarchar(10),@FromDate,120)+'''
and TransferEntry.DateCreated <= '''+CONVERT(nvarchar(10),@ToDate,120)+'''
and  TransferEntry.status>0
and TransferItems.status>0
group by ItemStoreNo) Transfer on Transfer.ItemStoreNo=itemMainAndStoreView.itemstoreid
    left  join
(select ItemStoreID,sum(qty) as qty
from ReceiveTransferEntry join ReceiveTransfer on ReceiveTransferEntry.ReceiveTransferID=ReceiveTransfer.ReceiveTransferID
where 1=1
 and  ReceiveTransferEntry.status>0
and ReceiveTransfer.status>0
and ReceiveTransferEntry.DateCREATE >= '''+ CONVERT(nvarchar(10),@FromDate,120)+'''
and ReceiveTransferEntry.DateCREATE <= '''+CONVERT(nvarchar(10),@ToDate,120)+'''
group by ItemStoreID) TransferReceive on TransferReceive.ItemStoreID=itemMainAndStoreView.itemstoreid
    left  join
(select ItemStoreNo,sum(qty)as qty
from AdjustInventory
where AdjustInventory.status>0
and AdjustInventory.DateCreated >= '''+ CONVERT(nvarchar(10),@FromDate,120)+'''
and AdjustInventory.DateCreated <= '''+CONVERT(nvarchar(10),@ToDate,120)+'''
group by ItemStoreNo) Adjust on Adjust.ItemStoreNo=itemMainAndStoreView.itemstoreid  where 1=1 and itemType!=2  '


  
set @GroupBy ='  
 group by StoreNo, Department,DepartmentID,SupplierName,SeasonName,StoreName'
print (@MySelect )
print ( @Filter + @GroupBy)
Execute (@MySelect + @Filter + @GroupBy)
GO
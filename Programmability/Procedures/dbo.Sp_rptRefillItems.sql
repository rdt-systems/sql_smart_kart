SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[Sp_rptRefillItems]
(
@Filter nvarchar(4000),
@StoreId1 uniqueidentifier,
@StoreId2 uniqueidentifier,
@StoreId3 uniqueidentifier,
@FromDate Datetime ='01/01/1900',
@ToDate Datetime ='12/31/2999'

)
AS

DECLARE @MySelect nvarchar(4000)

SET @MySelect ='


select StoreName,storeNo, ItemID,SupplierName,MainSupplierID,StyleNo,Name, Color, Size,Pattern,
QtyStore1,OnHandStore1,QtyStore2,OnHandStore2,QtyStore3,OnHandStore3,
qtyStore1+qtyStore2+qtyStore3 as TotalQty,
onhandStore1+onhandStore2+onhandStore3 as TotalOnHand
from (
select StoreName,storeno, itemmainandstoreview.ItemID,SupplierName,MainSupplierID,StyleNo,Name,Matrix1 as color,matrix2 as size,extName as Pattern,isnull(transactionentry.qty,0) as  qtyStore1 ,isnull(OnHand,0)  as  onhandStore1
,
isnull((select isnull(v.onhand,0)as onhand
from itemstore v
where v.ItemNo=itemmainandstoreview.ItemID
and v.StoreNo='''+CONVERT(nvarchar(max),@StoreId2)+'''
and v.status >0),0) as onhandStore2
,
isnull((select isnull(sum(qty),0)as qty
from transactionentry t , itemstore vv
where vv.ItemNo=itemmainandstoreview.ItemID
and vv.StoreNo='''+CONVERT(nvarchar(max),@StoreId2)+'''
and t.DateCreated >='+CONVERT(nvarchar(10),@FromDate,120)+'
and  t.DateCreated <='+CONVERT(nvarchar(10),@ToDate,120)+'
and vv.status >0),0)qtyStore2,

isnull((select isnull(v.onhand,0)as onhand
from itemstore v
where v.ItemNo=itemmainandstoreview.ItemID
and v.StoreNo='''+CONVERT(nvarchar(max),@StoreId3)+'''
and v.status >0),0) onhandStore3
,
isnull((select isnull(sum(qty),0) as qty
from transactionentry t , itemstore vv
where vv.ItemNo=itemmainandstoreview.ItemID
and vv.StoreNo='''+CONVERT(nvarchar(max),@StoreId3)+'''
and  t.DateCreated >='+CONVERT(nvarchar(10),@FromDate,120)+'
and  t.DateCreated <='+CONVERT(nvarchar(10),@ToDate,120)+'
and vv.status >0),0) qtyStore3
from itemmainandstoreview 
left outer join 
(select ItemStoreID,sum(qty)qty
from transactionentry
where transactionentry.DateCreated >='+CONVERT(nvarchar(10),@FromDate,120)+'
and  transactionentry.DateCreated <='+CONVERT(nvarchar(10),@ToDate,120)+'
and transactionentry.status >0
group by ItemStoreID)transactionentry
on  transactionentry.ItemStoreID=itemmainandstoreview.ItemStoreID

where 1=1 '+

@Filter+


'and storeno='''+CONVERT(nvarchar(max),@StoreId1)+'''
) as allStores
'


print (@MySelect  )
Execute (@MySelect  )
GO
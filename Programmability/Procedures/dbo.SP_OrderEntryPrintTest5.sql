SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SP_OrderEntryPrintTest5](@ID uniqueidentifier)
AS 







-----------




DECLARE @cols AS NVARCHAR(4000),
    @query  AS NVARCHAR(4000),
    @colsPivot AS NVARCHAR(4000)

select @colsPivot = 
  STUFF((SELECT distinct ', sum( IsNull(' + QUOTENAME(sss.size) +', 0)) as ['+ sss.size+']' 
                    from (           select items.*,PurchaseOrderEntry2.QtyOrdered
from (
select distinct PurchaseOrderEntry.[PurchaseOrderno],ItemStoreChields.ItemStoreID,itemMainChields.name,itemMainChields.matrix1 as color,itemMainChields.matrix2 as size,itemMainChields.barcodenumber
from itemmain as itemmain
join ItemStore 
on ItemStore.ItemNo =itemmain.itemid
left join itemmain as itemMainParent 
on itemMainParent.itemid =itemmain.linkno
left join  itemmain as itemMainChields
on  itemMainParent.itemid =itemmain.linkno
and itemMainChields.linkno =itemMainParent.itemid
left join ItemStore as ItemStoreChields
on ItemStoreChields.itemno=itemMainChields.itemid
and ItemStoreChields.StoreNo =ItemStore.StoreNo
left join PurchaseOrders  
on PurchaseOrders.storeno=ItemStore.storeno
left outer join PurchaseOrderEntry 
on PurchaseOrderEntry.ItemNo =ItemStore.itemstoreid
and PurchaseOrderEntry.[PurchaseOrderno]=[PurchaseOrders].[PurchaseOrderId]
where PurchaseOrderEntry.[PurchaseOrderno] =@ID
) as items 
  left outer join PurchaseOrderEntry as PurchaseOrderEntry2
on PurchaseOrderEntry2.ItemNo =items.ItemStoreID
and PurchaseOrderEntry2.[PurchaseOrderno] =items.[PurchaseOrderno]) as sss
					where 1=1
            FOR XML PATH(''), TYPE
            ).value('.', 'NVARCHAR(MAX)') 
        ,1,1,'')

select @cols = 
  STUFF((SELECT distinct ', ' + QUOTENAME(sss.size)  
                    from (           select items.*,PurchaseOrderEntry2.QtyOrdered
from (
select distinct PurchaseOrderEntry.[PurchaseOrderno],ItemStoreChields.ItemStoreID,itemMainChields.name,itemMainChields.matrix1 as color,itemMainChields.matrix2 as size,itemMainChields.barcodenumber
from itemmain as itemmain
join ItemStore 
on ItemStore.ItemNo =itemmain.itemid
left join itemmain as itemMainParent 
on itemMainParent.itemid =itemmain.linkno
left join  itemmain as itemMainChields
on  itemMainParent.itemid =itemmain.linkno
and itemMainChields.linkno =itemMainParent.itemid
left join ItemStore as ItemStoreChields
on ItemStoreChields.itemno=itemMainChields.itemid
and ItemStoreChields.StoreNo =ItemStore.StoreNo
left join PurchaseOrders  
on PurchaseOrders.storeno=ItemStore.storeno
left outer join PurchaseOrderEntry 
on PurchaseOrderEntry.ItemNo =ItemStore.itemstoreid
and PurchaseOrderEntry.[PurchaseOrderno]=[PurchaseOrders].[PurchaseOrderId]
where PurchaseOrderEntry.[PurchaseOrderno] =@ID
) as items 
  left outer join PurchaseOrderEntry as PurchaseOrderEntry2
on PurchaseOrderEntry2.ItemNo =items.ItemStoreID
and PurchaseOrderEntry2.[PurchaseOrderno] =items.[PurchaseOrderno]) as sss
					where 1=1
            FOR XML PATH(''), TYPE
            ).value('.', 'NVARCHAR(MAX)') 
        ,1,1,'')


set @query 
      = 'SELECT color,' + @colsPivot + ' from 
         (
		        select items.*,PurchaseOrderEntry2.QtyOrdered
from (
select distinct PurchaseOrderEntry.[PurchaseOrderno],ItemStoreChields.ItemStoreID,itemMainChields.name,itemMainChields.matrix1 as color,itemMainChields.matrix2 as size,itemMainChields.barcodenumber
from itemmain as itemmain
join ItemStore 
on ItemStore.ItemNo =itemmain.itemid
left join itemmain as itemMainParent 
on itemMainParent.itemid =itemmain.linkno
left join  itemmain as itemMainChields
on  itemMainParent.itemid =itemmain.linkno
and itemMainChields.linkno =itemMainParent.itemid
left join ItemStore as ItemStoreChields
on ItemStoreChields.itemno=itemMainChields.itemid
and ItemStoreChields.StoreNo =ItemStore.StoreNo
left join PurchaseOrders  
on PurchaseOrders.storeno=ItemStore.storeno
left outer join PurchaseOrderEntry 
on PurchaseOrderEntry.ItemNo =ItemStore.itemstoreid
and PurchaseOrderEntry.[PurchaseOrderno]=[PurchaseOrders].[PurchaseOrderId]
where PurchaseOrderEntry.[PurchaseOrderno] =''' + CONVERT(varchar(100), @ID) +'''
) as items 
  left outer join PurchaseOrderEntry as PurchaseOrderEntry2
on PurchaseOrderEntry2.ItemNo =items.ItemStoreID
and PurchaseOrderEntry2.[PurchaseOrderno] =items.[PurchaseOrderno]
         ) x
         pivot 
         (
            sum(QtyOrdered)
            for size in (' + @cols + ')
         ) p
		 group by color '

		 print (@query)
execute(@query)
GO
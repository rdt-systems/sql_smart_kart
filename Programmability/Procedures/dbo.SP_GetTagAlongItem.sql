SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SP_GetTagAlongItem]
(@Filter nvarchar(4000),
@TagAlongID uniqueidentifier)

as

Select ItemStoreID,TransactionID,Total,Qty
INTO #Temp1
From TransactionEntry
where ItemStoreID=@TagAlongID

declare @Select1 nvarchar(4000)
declare @Select2 nvarchar(4000)
declare @Select3 nvarchar(4000)

set @Select1=
'select TransactionEntryItem.[Name],
	   TransactionEntryItem.TransactionID ,
	   TransactionEntryItem.TransactionNo ,
	   TransactionEntryItem.StartSaleTime ,
	   TransactionEntryItem.Qty as ItemQty,
	   TransactionEntryItem.Total as ItemExtPrice,
	   #Temp1.Total as TagAlongExtPrice,
	   #Temp1.Qty as TagAlongQty
        

from TransactionEntryItem

INNER JOIN ItemStore  on TransactionEntryItem.ItemStoreID=ItemStore.ItemStoreID 
		   INNER JOIN #Temp1 on #Temp1.ItemStoreID=ItemStore.ExtraCharge1 and  #Temp1.TransactionID=TransactionEntryItem.TransactionID 

where Not Exists(select 1
			   from #Temp1
			   where #Temp1.ItemStoreID=TransactionEntryItem.ItemStoreID) ' 
	    
set @Select2=
' union all

select TransactionEntryItem.[Name],
	   TransactionEntryItem.TransactionID ,
	   TransactionEntryItem.TransactionNo ,
	   TransactionEntryItem.StartSaleTime ,
	   TransactionEntryItem.Qty as ItemQty,
	   TransactionEntryItem.Total as ItemExtPrice,
	   #Temp1.Total as TagAlongExtPrice,
	   #Temp1.Qty as TagAlongQty
       

from TransactionEntryItem

INNER JOIN ItemStore  on TransactionEntryItem.ItemStoreID=ItemStore.ItemStoreID 
		   INNER JOIN #Temp1 on #Temp1.ItemStoreID=ItemStore.ExtraCharge2 and  #Temp1.TransactionID=TransactionEntryItem.TransactionID 

where Not Exists(select 1
			   from #Temp1
			   where #Temp1.ItemStoreID=TransactionEntryItem.ItemStoreID) ' 
	  
Set @Select3=
' union all

select TransactionEntryItem.[Name],
	   TransactionEntryItem.TransactionID ,
	   TransactionEntryItem.TransactionNo ,
	   TransactionEntryItem.StartSaleTime ,
	   TransactionEntryItem.Qty as ItemQty,
	   TransactionEntryItem.Total as ItemExtPrice,
	   #Temp1.Total as TagAlongExtPrice,
	   #Temp1.Qty as TagAlongQty
       

from TransactionEntryItem

INNER JOIN ItemStore  on TransactionEntryItem.ItemStoreID=ItemStore.ItemStoreID 
		   INNER JOIN #Temp1 on #Temp1.ItemStoreID=ItemStore.ExtraCharge3 and  #Temp1.TransactionID=TransactionEntryItem.TransactionID 

where Not Exists(select 1
			   from #Temp1
			   where #Temp1.ItemStoreID=TransactionEntryItem.ItemStoreID) ' 

exec (@Select1+@Filter+@Select2+@Filter+@Select3+@Filter)


drop Table #Temp1
GO
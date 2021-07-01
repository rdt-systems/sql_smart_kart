SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SP_GetTagAlongSalesItem]
(@Filter nvarchar(4000))

as

declare @Select1 nvarchar(4000)
declare @Select2 nvarchar(4000)
declare @Select3 nvarchar(4000)
declare @Group nvarchar(4000)

set @Select1=
'Select TransactionEntry.ItemStoreID,[Name],TransactionID,Total
INTO #Temp1
From TransactionEntry
	  LEFT OUTER join ItemStore on ItemStore.ItemStoreID=TransactionEntry.ItemStoreID
	  LEFT OUTER join ItemMain  on ItemMain.ItemID=ItemStore.ItemNo 
where ItemType=5


select TransactionEntryView.[Name],
	   TransactionEntryView.ItemCode as BarcodeNumber,
       max(TransactionEntryView.Price) as Price,
       max(TransactionEntryView.OnHand) as OnHand,
	   TransactionEntryView.ModalNumber,
	   TransactionEntryView.ItemStoreID,
	   SUM(TransactionEntryView.Qty) as Qty,
	   SUM(#Temp1.Total) as ExtPrice,
	   #Temp1.Name as TagAlongName,
	   #Temp1.ItemStoreID as TagAlongID,
       StoreID
from TransactionEntryView

INNER JOIN ItemStore  on TransactionEntryView.ItemStoreID=ItemStore.ItemStoreID 
		   INNER JOIN #Temp1 on #Temp1.ItemStoreID=ItemStore.ExtraCharge1 and  #Temp1.TransactionID=TransactionEntryView.TransactionID 
INNER JOIN dbo.[Transaction] on TransactionEntryView.TransactionID=dbo.[Transaction].TransactionID

where [Transaction].Status>0 '

set @Select2=
' union all

select TransactionEntryView.[Name],
	   TransactionEntryView.ItemCode as BarcodeNumber,
       max(TransactionEntryView.Price) as Price,
       max(TransactionEntryView.OnHand) as OnHand,
	   TransactionEntryView.ModalNumber,
	   TransactionEntryView.ItemStoreID,
	   SUM(TransactionEntryView.Qty) as Qty,
	   SUM(#Temp1.Total) as ExtPrice,
	   #Temp1.Name as TagAlongName,
	   #Temp1.ItemStoreID as TagAlongID,
       StoreID
	 
from TransactionEntryView

INNER JOIN ItemStore  on TransactionEntryView.ItemStoreID=ItemStore.ItemStoreID 
		   INNER JOIN #Temp1 on #Temp1.ItemStoreID=ItemStore.ExtraCharge2 and  #Temp1.TransactionID=TransactionEntryView.TransactionID 
INNER JOIN dbo.[Transaction] on TransactionEntryView.TransactionID=dbo.[Transaction].TransactionID

where [Transaction].Status>0 '

set @Select3=
' union all

select TransactionEntryView.[Name],
	   TransactionEntryView.ItemCode as BarcodeNumber,
       max(TransactionEntryView.Price) as Price,
       max(TransactionEntryView.OnHand) as OnHand,
	   TransactionEntryView.ModalNumber,
 	   TransactionEntryView.ItemStoreID,
       SUM(TransactionEntryView.Qty) as Qty,
	   SUM(#Temp1.Total) as ExtPrice,
	   #Temp1.Name as TagAlongName,
	   #Temp1.ItemStoreID as TagAlongID,
       StoreID
	 
from TransactionEntryView

INNER JOIN ItemStore  on TransactionEntryView.ItemStoreID=ItemStore.ItemStoreID 
		   INNER JOIN #Temp1 on #Temp1.ItemStoreID=ItemStore.ExtraCharge3 and  #Temp1.TransactionID=TransactionEntryView.TransactionID 
INNER JOIN dbo.[Transaction] on TransactionEntryView.TransactionID=dbo.[Transaction].TransactionID

where [Transaction].Status>0 '

set @Group=
	' And TransactionEntryView.Status>0 and 
	  Not Exists(select 1
			   from #Temp1
			   where #Temp1.ItemStoreID=TransactionEntryView.ItemStoreID) 
	   
Group by 	  
	  TransactionEntryView.[Name],
	  TransactionEntryView.ItemCode ,
	  TransactionEntryView.ModalNumber,
	  TransactionEntryView.ItemStoreID,
	  #Temp1.Name,
	  #Temp1.ItemStoreID,
       StoreID '

exec (@Select1+@Filter+@Group+@Select2+@Filter+@Group+@Select3+@Filter+@Group)

drop Table #Temp1
GO
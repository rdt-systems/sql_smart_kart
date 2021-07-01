SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SP_TransferW]

AS

BEGIN


--create table ItemNotExistsOtherStore(BarcodeNumber varchar(100),FromDb varchar(100) ,Todb varchar(100),Qty decimal ,PhoneOrderID uniqueidentifier ,ItemStoreID uniqueidentifier  )

DECLARE @ItemStoreID uniqueidentifier

DECLARE @FromDb varchar(50)
DECLARE @Todb varchar(50)
DECLARE @BarcodeNumber varchar(50)
DECLARE @QtyTranfer decimal
DECLARE @PhoneOrderID uniqueidentifier
DECLARE @onHand decimal
DECLARE @Cost decimal
DECLARE @PhoneOrderNo varchar(50)

DECLARE c10 CURSOR FORWARD_ONLY STATIC OPTIMISTIC FOR
select DB_NAME() as FromDb, case   Customer.CustomerNo
when  '(718)388-7555' then 'WineCave' 
when '(347)240-6700' then 'BPWine'
when '(718)338-4166' then 'LiquorsGalore' end as Todb,
ItemMain.BarcodeNumber,
PhoneOrderEntry.PhoneOrderID,
PhoneOrderEntry.ItemStoreNo,
case when PhoneOrderEntry.UOMType=2 then PhoneOrderEntry.Qty *ItemMain.CaseQty else PhoneOrderEntry.Qty end as Qty,
ItemStore.onHand,
ItemStore.Cost,
'P '+PhoneOrder.PhoneOrderNo as PhoneOrderNo
from PhoneOrderEntry  join PhoneOrder on PhoneOrder.PhoneOrderID = PhoneOrderEntry.PhoneOrderID
join Customer on PhoneOrder.CustomerID=Customer.CustomerID
join ItemStore on ItemStore.ItemStoreID=PhoneOrderEntry.ItemStoreNo
join ItemMain on ItemMain.ItemID=ItemStore.ItemNo
and  CustomerNo in ('(718)388-7555','(347)240-6700','(718)338-4166')
and PhoneOrder.Status=1
and PhoneOrderEntry.Status=1
and PhoneOrder.PhoneOrderStatus=0
order by PhoneOrder.PhoneOrderID,PhoneOrderEntry.DateCreated desc
OPEN c10

FETCH NEXT FROM c10
INTO @FromDb,@Todb,@BarcodeNumber ,@PhoneOrderID,@ItemStoreID,@QtyTranfer,@onHand,@Cost,@PhoneOrderNo

WHILE @@FETCH_STATUS = 0

		Begin
		DECLARE @NewId uniqueidentifier 
		set @NewId =newid()

        DECLARE @QtyTranferMinus decimal 
	   set @QtyTranferMinus =@QtyTranfer*-1

	 exec 	
 SP_AdjustInventoryInsert 
@AdjustInventoryId = @NewId,
@ItemStoreNo =@ItemStoreID,
@Qty = @QtyTranferMinus  ,
@OldQty=@onHand,
@AdjustType=0,
@AdjustReason=@PhoneOrderNo,
@AccountNo =0,
@Cost=@Cost,
@Status=1,
@AdjustDate=null,
@ModifierID ='12345678-9100-ABCD-ABCD-12345678ABCD'



DECLARE @StringExe nvarchar(4000) 
DECLARE @StringExe1 nvarchar(4000) 
DECLARE @StringExe2 nvarchar(4000) 

set @StringExe =
'INSERT INTO '+@Todb+'.dbo.AdjustInventory
                      (AdjustInventoryId, ItemStoreNo, Qty, OldQty, AdjustType, AdjustReason, AccountNo,Cost, Status, DateCreated, UserCreated, DateModified, UserModified)
select newid(),ItemMainAndStoreview.itemStoreId,'+convert(varchar(500),@QtyTranfer)+',ItemMainAndStoreview.OnHand, 0,'''+@PhoneOrderNo+''',0, ItemMainAndStoreview.Cost,1,dbo.GetLocalDate(), ''12345678-9100-ABCD-ABCD-12345678ABCD'',
dbo.GetLocalDate(), ''12345678-9100-ABCD-ABCD-12345678ABCD''
from '+@Todb+'.dbo.ItemMainAndStoreview
where BarcodeNumber='''+@BarcodeNumber+''''


print @StringExe

DECLARE @ToDbItemStoreId uniqueidentifier   = null
set @StringExe1 =
'select top 1 @ToDbItemStoreId= ItemMainAndStoreview.itemStoreId
from '+@Todb+'.dbo.ItemMainAndStoreview
where BarcodeNumber='''+@BarcodeNumber+'''' 

print @StringExe1

exec sp_executesql @statement=@StringExe1 , @params=N'@ToDbItemStoreId uniqueidentifier OUTPUT ', @ToDbItemStoreId=@ToDbItemStoreId OUTPUT
print @ToDbItemStoreId

if  @ToDbItemStoreId is null
begin
print 'ItemNotExistsOtherStore ' 
insert into  ItemNotExistsOtherStore(BarcodeNumber ,FromDb  ,Todb ,Qty ,PhoneOrderID ,ItemStoreID )
values (@BarcodeNumber,@FromDb,@Todb,@QtyTranfer,@PhoneOrderID,@ItemStoreID)
end

else
begin 
print @StringExe
exec sp_executesql @StringExe 

Exec SP_UpdateOnHandOneItem @ItemStoreID = @ItemStoreID

set @StringExe2 = 'exec '+@Todb+'.dbo.SP_UpdateOnHandOneItem @ItemStoreID = '''+convert(varchar(50),@ToDbItemStoreId)+''''

print @StringExe2
exec sp_executesql  @StringExe2
end 


	FETCH NEXT FROM c10
     INTO @FromDb,@Todb,@BarcodeNumber ,@PhoneOrderID,@ItemStoreID,@QtyTranfer,@onHand,@Cost ,@PhoneOrderNo
	END

CLOSE c10
DEALLOCATE c10

UPDATE       PhoneOrder
SET                PhoneOrderStatus = 2, DateModified = GETDATE()
FROM            PhoneOrderEntry INNER JOIN
                         PhoneOrder ON PhoneOrder.PhoneOrderID = PhoneOrderEntry.PhoneOrderID INNER JOIN
                         Customer ON PhoneOrder.CustomerID = Customer.CustomerID INNER JOIN
                         ItemStore ON ItemStore.ItemStoreID = PhoneOrderEntry.ItemStoreNo INNER JOIN
                         ItemMain ON ItemMain.ItemID = ItemStore.ItemNo AND Customer.CustomerNo IN ('(718)388-7555', '(347)240-6700', '(718)338-4166') AND PhoneOrder.Status = 1 
						 AND       PhoneOrderEntry.Status = 1 AND PhoneOrder.PhoneOrderStatus = 0
END
GO
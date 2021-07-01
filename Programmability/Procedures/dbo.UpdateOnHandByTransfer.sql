SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[UpdateOnHandByTransfer]
(@TransferID uniqueidentifier,
 @Del Smallint=1,
 @ModifierID uniqueidentifier)

as
return

if ((select status From TransferItems Where TransferID=@TransferID)>0 And @Del=1) Or @Del=-1
BEGIN

Declare @FromStore uniqueidentifier
Set @FromStore=(SELECT FromStoreID 
				FROM   TransferItems
				WHERE  TransferID=@TransferID)

Declare @ToStore uniqueidentifier
Set @ToStore=(SELECT ToStoreID 
			  FROM   TransferItems
			  WHERE  TransferID=@TransferID)

Declare @ItemStoreID uniqueidentifier
Declare @ItemID uniqueidentifier
Declare @FromItemStoreID uniqueidentifier
Declare @ToItemStoreID uniqueidentifier
declare @RequestTransferEntryID uniqueidentifier
DECLARE @Qty money

DECLARE c10 CURSOR FORWARD_ONLY STATIC OPTIMISTIC FOR
SELECT ItemStoreNo,Qty 
FROM   dbo.TransferEntry 
where (@TransferID=TransferID) AND Status>0

OPEN c10

FETCH NEXT FROM c10
INTO @ItemStoreID,@Qty

WHILE @@FETCH_STATUS = 0

		Begin

		SELECT @ItemID =ItemNo FROM ItemStore where Itemstoreid = @ItemStoreID
		SELECT @FromItemStoreID = @ItemStoreID
		SELECT @ToItemStoreID = ItemStoreID From ItemStore Where ItemNo = @ItemID And StoreNo = @ToStore
		print 1

		Exec SP_UpdateOnHandOneItem @FromItemStoreID
		print 2
		Exec SP_UpdateOnHandOneItem @ToItemStoreID

		--Set @Qty=@Del*@Qty
		-- EXEC  UpdateMultiParent @ItemNo,@ModifierID,@FromStore,@ToStore,0,1,@Qty


				FETCH NEXT FROM c10
				INTO @ItemStoreID,@Qty
		END

CLOSE c10
DEALLOCATE c10

END
GO
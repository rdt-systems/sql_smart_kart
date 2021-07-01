SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[UpdateOnOrderAndOnTransfer]
(@TransferOrderID uniqueidentifier,
 @Del Smallint=1,
 @ModifierID uniqueidentifier)

as

if ((select status From TransferOrder Where TransferOrderID=@TransferOrderID)>0 And @Del=1) Or @Del=-1
BEGIN

Declare @FromStore uniqueidentifier
Set @FromStore=(SELECT FromStoreID 
				FROM   TransferOrder
				WHERE  TransferOrderID=@TransferOrderID)

Declare @ToStore uniqueidentifier
Set @ToStore=(SELECT ToStoreID 
			  FROM   TransferOrder
			  WHERE  TransferOrderID=@TransferOrderID)


DECLARE @ItemNo uniqueidentifier
DECLARE @Qty money

DECLARE c10 CURSOR FORWARD_ONLY STATIC OPTIMISTIC FOR
SELECT ItemStoreNo,Qty 
FROM   dbo.TransferOrderEntry 
where (@TransferOrderID=TransferOrderID) AND Status>0

OPEN c10

FETCH NEXT FROM c10
INTO @ItemNo,@Qty

WHILE @@FETCH_STATUS = 0

		Begin

		UPDATE dbo.ItemStore
		SET OnTransferOrder = isnull(OnTransferOrder,0) + @Qty * @Del, 
			DateModified = dbo.GetLocalDATE(), 
			UserModified = @ModifierID
		WHERE ItemStoreID = (SELECT ItemStoreID
							 FROM   ItemStore
							 WHERE  @ItemNo=ItemNo And StoreNo=@FromStore)

		UPDATE dbo.ItemStore
		SET OnOrder = isnull(OnOrder,0) + @Qty * @Del , 
			DateModified = dbo.GetLocalDATE(), 
			UserModified = @ModifierID
		WHERE ItemStoreID = (SELECT ItemStoreID
							 FROM   ItemStore
							 WHERE  @ItemNo=ItemNo And StoreNo=@ToStore)

        Set @Qty=@Del*@Qty
        EXEC  UpdateMultiParent @ItemNo,@ModifierID,@FromStore,@ToStore,1,0,@Qty

				FETCH NEXT FROM c10
				INTO @ItemNo,@Qty
		END

CLOSE c10
DEALLOCATE c10

END
GO
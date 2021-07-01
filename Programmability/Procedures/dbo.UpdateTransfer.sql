SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[UpdateTransfer]
(
@TransferNo nvarchar(20),
@ToStoreID uniqueidentifier,
@ModifierID uniqueidentifier,
@Result nvarchar(20) output
)


as

declare @TransferID uniqueidentifier


Set @TransferID = (Select Transferid From TransferItems where TransferNo = @TransferNo and status > -1)

if @TransferID is null 
begin
Set @Result = 'Transfer Not Found.'
Return
end


if ((select status From TransferItems Where TransferID=@TransferID)>0 )
BEGIN

Declare @FromStore uniqueidentifier
Set @FromStore=(SELECT FromStoreID 
				FROM   TransferItems
				WHERE  TransferID=@TransferID)

/*Declare @ToStore uniqueidentifier
Set @ToStore=(SELECT ToStoreID 
			  FROM   TransferItems
			  WHERE  TransferID=@TransferID)
			  */

DECLARE @ItemNo uniqueidentifier
DECLARE @Qty money

DECLARE c10 CURSOR FORWARD_ONLY STATIC OPTIMISTIC FOR
SELECT ItemStoreNo,Qty 
FROM   dbo.TransferEntry 
where (@TransferID=TransferID) AND Status>0

OPEN c10

FETCH NEXT FROM c10
INTO @ItemNo,@Qty

WHILE @@FETCH_STATUS = 0

		Begin

		UPDATE dbo.ItemStore
		SET OnHand = isnull(OnHand,0) - @Qty, 
			DateModified = dbo.GetLocalDATE(), 
			UserModified = @ModifierID
		WHERE ItemStoreID = (SELECT ItemStoreID
							 FROM   ItemStore
							 WHERE  @ItemNo=ItemNo And StoreNo= @FromStore)

		UPDATE dbo.ItemStore
		SET OnHand = isnull(OnHand,0) + @Qty , 
			DateModified = dbo.GetLocalDATE(), 
			UserModified = @ModifierID
		WHERE ItemStoreID = (SELECT ItemStoreID
							 FROM   ItemStore
							 WHERE  @ItemNo=ItemNo And StoreNo=@ToStoreID)

		Set @Qty=@Qty
        EXEC  UpdateMultiParent @ItemNo,@ModifierID,@FromStore,@ToStoreID,0,1,@Qty


				FETCH NEXT FROM c10
				INTO @ItemNo,@Qty
		END

CLOSE c10
DEALLOCATE c10
Set @Result = 'Transfer Complete.'
END
GO
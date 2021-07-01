SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SP_DamageItemInsert]
(
@DamageItemID uniqueidentifier,
@ItemStoreID uniqueidentifier,
@Qty int,
@DamageStatus int,
@TransactionEntryID uniqueidentifier ,
@ReturnEntryID uniqueidentifier,
@Date DateTime,
@Status smallint,
@ModifierID uniqueidentifier)
AS 

Declare @UpdateTime datetime
set  @UpdateTime =dbo.GetLocalDATE()

INSERT INTO dbo.DamageItem
                      (DamageItemID, ItemStoreID , Qty, DamageStatus, TransactionEntryID ,ReturnEntryID,
						Date,Status, DateCreated, UserCreated, DateModified, UserModified)
VALUES                (@DamageItemID, @ItemStoreID , @Qty, @DamageStatus, @TransactionEntryID,@ReturnEntryID,
						@Date,@Status, @UpdateTime, @ModifierID, @UpdateTime, @ModifierID)

--if @DamageStatus<>1

--	UPDATE dbo.ItemStore
--	SET OnHand = isnull(OnHand,0) - @Qty , 
--		DateModified = dbo.GetLocalDATE(), 
--		UserModified = @ModifierID
--	WHERE ItemStoreID = @ItemStoreID
--EXEC UpdateParent @ItemStoreID,@ModifierID,1,0,0
select @UpdateTime as DateModified
GO
SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SP_ReturnItemInsert]
(@ReturnItemId uniqueidentifier,
@TransactionEntryID uniqueidentifier,
@SaleEntryID uniqueidentifier,
@ReturnReason nvarchar(4000),
@ReturnedStateType int,
@Status smallint,
@ModifierID uniqueidentifier)
AS INSERT INTO dbo.ReturnItem
                      (ReturnItemID, TransactionEntryID, SaleEntryID, ReturnReason, ReturnedStateType, Status, DateCreated, UserCreated, DateModified, UserModified)
VALUES     (@ReturnItemID, @TransactionEntryID, @SaleEntryID, @ReturnReason, @ReturnedStateType, @Status, dbo.GetLocalDATE(), @ModifierID, dbo.GetLocalDATE(), 
                      @ModifierID)
GO
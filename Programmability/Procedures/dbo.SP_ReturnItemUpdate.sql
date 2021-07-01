SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SP_ReturnItemUpdate]
(@ReturnItemId uniqueidentifier,
@TransactionEntryID uniqueidentifier,
@SaleEntryID uniqueidentifier,
@ReturnReason nvarchar(4000),
@ReturnedStateType int,
@Status smallint,
@DateModified datetime,
@ModifierID uniqueidentifier)

AS 

Declare @UpdateTime datetime
set  @UpdateTime =dbo.GetLocalDATE()

UPDATE dbo.ReturnItem
             
SET        TransactionEntryID= @TransactionEntryID,
                SaleEntryID = @SaleEntryID,
	ReturnReason= @ReturnReason,
	ReturnedStateType= @ReturnedStateType, 
	Status=@Status,     
	DateModified=@UpdateTime,
	UserModified= @ModifierID

WHERE (ReturnItemID=@ReturnItemID) and  (DateModified = @DateModified or DateModified is NULL)




select @UpdateTime as DateModified
GO
SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SP_PayToBillInsert]
(@PayToBillID uniqueidentifier,
@SuppTenderID uniqueidentifier,
@BillID uniqueidentifier,
@Amount money,
@Note nvarchar(4000),
@IsReturn bit,
@Status smallint,
@ModifierID uniqueidentifier)



AS INSERT INTO dbo.PayToBill
(PayToBillID,     SuppTenderID,               BillID , Amount,       Note,IsReturn,    Status, DateCreated, UserCreated, dateModified, UserModified )

VALUES     (@PayToBillID, @SuppTenderID,          @BillID , @Amount, @Note,@IsReturn,        1, dbo.GetLocalDATE(),       @ModifierId,   dbo.GetLocalDATE(),      @ModifierId)


Update dbo.Bill
Set AmountPay = (isnull(AmountPay,0)+ @Amount),DateModified =dbo.GetLocalDATE()
Where  BillID = @BillID
GO
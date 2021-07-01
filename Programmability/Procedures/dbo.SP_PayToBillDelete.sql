SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SP_PayToBillDelete]
(@PayToBillID uniqueidentifier,
@ModifierID uniqueidentifier)

As

Declare @OldStatus Decimal 
Set @OldStatus =(Select Status From dbo.PayToBill where  PayToBillID = @PayToBillID)

Update  dbo.PayToBill
SET Status = -1 , dateModified =   dbo.GetLocalDATE(),   UserModified  = @ModifierId
where PayToBillID = @PayToBillID

if @OldStatus=1
begin

Declare @CAmount money 
Set @CAmount =(Select Amount From dbo.PayToBill where  PayToBillID = @PayToBillID)

Declare @BillID Uniqueidentifier 
Set @BillID =(Select BillID From dbo.PayToBill where  PayToBillID = @PayToBillID)

Update dbo.Bill
Set AmountPay = (isnull(AmountPay,0) - @CAmount),DateModified =dbo.GetLocalDATE()
Where  BillID = @BillID

end
GO
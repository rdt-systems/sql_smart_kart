SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SP_PayToBillUpdate]
(@PayToBillID uniqueidentifier,
@SuppTenderID uniqueidentifier,
@BillID uniqueidentifier,
@Amount money,
@Note nvarchar(4000),
@IsReturn bit,
@Status smallint,
@DateModified datetime,
@ModifierID uniqueidentifier)

As

Declare @UpdateTime datetime
set  @UpdateTime =dbo.GetLocalDATE()

Update  dbo.PayToBill

SET  
SuppTenderID= @SuppTenderID, 
BillID = @BillID , 
Amount = @Amount, 
Note = @Note,
IsReturn=@IsReturn, 
Status = @Status, 
dateModified =   @UpdateTime,  
 UserModified  = @ModifierId

WHERE  (PayToBillID = @PayToBillID) AND 
      (DateModified = @DateModified OR DateModified IS NULL)

if @Status = 0

Update dbo.Bill
Set
 AmountPay = (isnull(AmountPay,0)  - @Amount),
DateModified =@UpdateTime
Where  BillID = @BillID

select @UpdateTime as DateModified
GO
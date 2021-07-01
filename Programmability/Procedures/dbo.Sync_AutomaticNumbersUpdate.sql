SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[Sync_AutomaticNumbersUpdate]
(

@PocketID uniqueidentifier,
@InvOrPay nvarchar(50),
@SaleOrder nvarchar(50),
@ReturnCustomer nvarchar(50),
--@Payment nvarchar(50),
@Receive nvarchar(50),
@ReturnSupplier nvarchar(50),
@PaymentSupplier nvarchar(50),
@DateModified datetime=null,
@ModifierID uniqueidentifier
)

as
UPDATE PPComp
SET
InvoiceNum= @InvOrPay,
SaleOrderNum= @SaleOrder,
ReturnNum= @ReturnCustomer,
--PaymentNum= @Payment,
ReceiveNum= @Receive,
ReturnSupplierNum= @ReturnSupplier,
PaymentSupplierNum= @PaymentSupplier,
DateModified=dbo.GetLocalDATE(),
UserModified= @ModifierID


WHERE (PPCompID = @PocketID)
GO
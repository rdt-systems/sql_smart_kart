SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SP_PPCompUpdate]
(@PPCompID uniqueidentifier,
@PPCName nvarchar(50),
@InvoiceNum nvarchar(50),
@ReturnNum nvarchar(50),
@PaymentNum nvarchar(50),
@SaleOrderNum nvarchar(50),
@ReceiveNum nvarchar(50),
@ReturnSupplierNum nvarchar(50),
@PaymentSupplierNum nvarchar(50),
@Status smallint,
@DateModified datetime,
@ModifierID uniqueidentifier)
AS 

Declare @UpdateTime datetime
set  @UpdateTime =dbo.GetLocalDATE()

UPDATE dbo.PPComp

SET 
PPCName= dbo.CheckString(@PPCName),
InvoiceNum= @InvoiceNum,
ReturnNum= @ReturnNum,
PaymentNum= @PaymentNum,
SaleOrderNum=@SaleOrderNum,
ReceiveNum= @ReceiveNum,
ReturnSupplierNum= @ReturnSupplierNum,
PaymentSupplierNum= @PaymentSupplierNum,
Status=@Status,
DateModified=@UpdateTime,
UserModified= @ModifierID


WHERE (PPCompID = @PPCompID) AND 
      (DateModified = @DateModified OR DateModified IS NULL) 





select @UpdateTime as DateModified
GO
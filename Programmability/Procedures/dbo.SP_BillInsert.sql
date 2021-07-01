SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SP_BillInsert]
(@BillID uniqueidentifier,
@BillNo nvarchar(50),
@SupplierID uniqueidentifier,
@Discount decimal(9, 3),
@Amount money,
@AmountPay money,
@BillDate datetime,
@BillDue datetime,
@PersonGet uniqueidentifier,
@TermsID uniqueidentifier,
@Note nvarchar(4000),
@Taxable bit,
@TaxRate decimal(19,4),
@TaxAmount money,
@Status smallint,
@ModifierID uniqueidentifier)
AS INSERT INTO dbo.Bill
                      (BillID,  BillNo,  SupplierID,  Discount,   Amount, AmountPay,   BillDate,BillDue,   PersonGet,TermsID
  ,Note,Taxable,TaxRate,TaxAmount, Status, DateCreated, UserCreated, DateModified, UserModified)
VALUES                (@BillID, @BillNo, @SupplierID, @Discount,  ROUND(@Amount,2), @AmountPay, @BillDate,@BillDue, @PersonGet,@TermsID,
 @Note,@Taxable,@TaxRate,@TaxAmount,      1,   dbo.GetLocalDATE(), @ModifierID,    dbo.GetLocalDATE(),  @ModifierID)
GO
SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SP_BillUpdate]
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
@DateModified datetime,
@ModifierID uniqueidentifier)

AS 

Declare @UpdateTime datetime
set  @UpdateTime =dbo.GetLocalDATE()

Update dbo.Bill

   
  SET        BillNo = @BillNo, SupplierID = @SupplierID, Discount = @Discount  ,Amount =  ROUND(@Amount,2), AmountPay = @AmountPay, BillDate = 

@BillDate, BillDue=@BillDue,
              PersonGet =@PersonGet,TermsID=@TermsID
, Note= @Note,  
Taxable=@Taxable,
TaxRate=@TaxRate,
TaxAmount=@taxAmount,
Status=isnull(@Status,1) ,DateModified = @UpdateTime, UserModified =@ModifierID
   
  WHERE   ( BillID = @BillID )  AND 
      (  (DateModified = @DateModified) OR (DateModified is NULL)  Or
         (@DateModified is null)
      )

select @UpdateTime as DateModified
GO
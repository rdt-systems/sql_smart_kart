SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SP_ReturnToVenderUpdate]
(@ReturnToVenderID  uniqueidentifier,
@ReturnToVenderNo nvarchar(50),
@StoreNo uniqueidentifier,
@SupplierID uniqueidentifier,
@PersonReturnID uniqueidentifier,
@Total money,
@Note nvarchar(4000),
@ReturnToVenderDate  datetime,
@Taxable bit,
@TaxRate decimal(19,4),
@TaxAmount money,
@Status smallint,
@DateModified datetime,
@ModifierID uniqueidentifier,
@Discount float,
@IsDiscountInAmount bit
)

As

Declare @UpdateTime datetime
set  @UpdateTime =dbo.GetLocalDATE()


 UPDATE dbo.ReturnToVender 
 SET           ReturnToVenderNo= @ReturnToVenderNo,StoreNo=@StoreNo, SupplierID= @SupplierID, PersonReturnID = @PersonReturnID, 

Total=  @Total,Note =  @Note, ReturnToVenderDate  = @ReturnToVenderDate, 
Taxable=@Taxable,
TaxRate=@TaxRate,
TaxAmount=@TaxAmount,
 Status = @Status, DateModified = @UpdateTime, UserModified = @ModifierID,
Discount = @Discount,
IsDiscountInAmount = @IsDiscountInAmount 

WHERE  (ReturnToVenderID  = @ReturnToVenderID) and  (DateModified = @DateModified or DateModified is NULL)



select @UpdateTime as DateModified
GO
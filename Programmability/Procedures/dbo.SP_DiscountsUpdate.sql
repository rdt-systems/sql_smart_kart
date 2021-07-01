SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SP_DiscountsUpdate]
(@DiscountID uniqueidentifier,
@Name nvarchar(50),
@StartDate datetime,
@EndDate datetime,
@PercentsDiscount money,
@AmountDiscount money,
@MinTotalSale money,
@UPCDiscount nvarchar(50),
@Status smallint,
@ReqPaswrd bit,
@SalesItem bit,
@DiscountItems bit,
@DiscountForCC money,
@PercentsDiscount2 money =null,
@AmountDiscount2 money =null,
@MinTotalSale2 money= null,
@PercentsDiscount3 money= null,
@AmountDiscount3 money= null,
@MinTotalSale3 money= null,
@DiscountType int = null,
@IncludeGiftCard bit = 0,
@DiscountItem int=0,
@DiscountDepartment int =0,
@DiscountBrand int=0,
@DiscountStore int=0,
@DateModified datetime,
@BogoType Int =0,
@BogoQty Int=0,
@BogoAmount decimal(18, 0) =0,
@ModifierID uniqueidentifier,
@ClearDays Int =NULL,
@SelectedItem bit = NULL,
@MaxAmount money = NULL,
@AutoAssign bit = NULL,
@MinQty int =NULL
)
AS 

Declare @UpdateTime datetime
set  @UpdateTime =dbo.GetLocalDATE()

UPDATE dbo.Discounts

SET 
[Name]= dbo.CheckString(@Name),
StartDate= @StartDate,
EndDate= @EndDate,
PercentsDiscount= @PercentsDiscount,
AmountDiscount=@AmountDiscount,
MinTotalSale=@MinTotalSale,
UPCDiscount=@UPCDiscount,
Status=@Status,
DateModified=@UpdateTime,
UserModified= @ModifierID,
ReqPaswrd = @ReqPaswrd,
SalesItem=@SalesItem ,
DiscountItems =@DiscountItems,
DiscountForCC = @DiscountForCC,
PercentsDiscount2=@PercentsDiscount2,
AmountDiscount2=@AmountDiscount2 ,
MinTotalSale2=@MinTotalSale2 ,
PercentsDiscount3=@PercentsDiscount3,
AmountDiscount3=@AmountDiscount3 ,
MinTotalSale3=@MinTotalSale3,
DiscountType = @DiscountType,
IncludeGiftCard =@IncludeGiftCard,
DiscountItem =  @DiscountItem ,
DiscountDepartment = @DiscountDepartment,
DiscountBrand = @DiscountBrand,
DiscountStore = @DiscountStore,
BogoType=@BogoType,
BogoQty=@BogoQty,
BogoAmount=@BogoAmount,
ClearDays = @ClearDays,
SelectedItem =  @SelectedItem,
MaxAmount = @MaxAmount,
AutoAssign=@AutoAssign,
MinQty=@MinQty

WHERE (DiscountID = @DiscountID) AND 
      (DateModified = @DateModified OR DateModified IS NULL) 





select @UpdateTime as DateModified
GO
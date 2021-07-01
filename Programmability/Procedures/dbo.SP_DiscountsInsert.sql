SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SP_DiscountsInsert]
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
@BogoType Int =0,
@BogoQty Int=0,
@BogoAmount decimal(18, 0) =0,
@ModifierID uniqueidentifier,
@ClearDays int = NULL,
@SelectedItem bit = NULL,
@MaxAmount money = NULL,
@AutoAssign bit = NULL,
@MinQty int = NULL
)
AS INSERT INTO dbo.Discounts
                      (DiscountID, [Name], StartDate, EndDate, PercentsDiscount, AmountDiscount,MinTotalSale,UPCDiscount, Status,ReqPaswrd,SalesItem,DiscountItems,DiscountForCC,
						PercentsDiscount2,AmountDiscount2,MinTotalSale2,PercentsDiscount3,AmountDiscount3,MinTotalSale3, 
                      DateCreated, UserCreated, DateModified, UserModified, DiscountType,IncludeGiftCard,
					  DiscountItem,DiscountDepartment,DiscountBrand,DiscountStore,BogoType,BogoQty,BogoAmount, ClearDays, SelectedItem, MaxAmount,AutoAssign, MinQty)
VALUES     (@DiscountID, dbo.CheckString(@Name), @StartDate, @EndDate, @PercentsDiscount, @AmountDiscount,@MinTotalSale,@UPCDiscount, 1,@ReqPaswrd,@SalesItem,@DiscountItems,@DiscountForCC, 
			@PercentsDiscount2,@AmountDiscount2,@MinTotalSale2,@PercentsDiscount3,@AmountDiscount3,@MinTotalSale3, 
dbo.GetLocalDATE(), @ModifierID, dbo.GetLocalDATE(), @ModifierID, @DiscountType,@IncludeGiftCard,
@DiscountItem,@DiscountDepartment,@DiscountBrand,@DiscountStore,@BogoType,@BogoQty,@BogoAmount,@ClearDays, @SelectedItem, @MaxAmount,@AutoAssign, @MinQty)
GO
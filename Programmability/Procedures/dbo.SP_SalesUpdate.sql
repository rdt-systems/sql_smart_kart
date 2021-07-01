SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SP_SalesUpdate]
(	@SaleID uniqueidentifier,
	@SaleNo nvarchar(50),
	@SaleName nvarchar(200) ,
	@FromDate datetime,
	@ToDate datetime,
	@BuyQty decimal(18, 0) ,
	@GetQty decimal(18, 0) ,
	@MaxQty decimal(18, 0) ,
	@MinTotalAmount money,
	@MinTotalQty decimal(18, 0) ,
	@SaleType int,
	@Price money,
	@Percentage decimal(18, 0) ,
	@AmountLess money,
    @NoTax bit,
	@Priority int,
	@AllowMultiSales bit,
	@IsGeneral bit,
	@IsCoupon bit,
	@AllItemsPoints	bit	,
    @IncludeNotDiscountable	bit	,
    @IncludePhoneOrder	bit	,
    @PointsSum	money,
    @PointsAmount int	,
    @PointsPerCoin int,
    @Status	smallint,
	@DateModified datetime,	
	@ModifierID uniqueidentifier
)
AS

Declare @UpdateTime datetime
set  @UpdateTime =dbo.GetLocalDATE()

UPDATE [dbo].[Sales]
   SET [SaleNo] = @SaleNo
      ,[SaleName] = @SaleName
      ,[FromDate] = @FromDate
      ,[ToDate] = @ToDate
      ,[BuyQty] = @BuyQty
      ,[GetQty] = @GetQty
      ,[MaxQty] = @MaxQty
      ,[MinTotalAmount] = @MinTotalAmount
      ,[MinTotalQty] = @MinTotalQty
      ,[SaleType] = @SaleType
      ,[Price] = @Price
      ,[Percentage] = @Percentage
	  ,[AmountLess]= @AmountLess
      ,[NoTax]= @NoTax
      ,[Priority] = @Priority
      ,[AllowMultiSales] = @AllowMultiSales
      ,[IsGeneral] = @IsGeneral
      ,[IsCoupon] = @IsCoupon
      ,AllItemsPoints =  @AllItemsPoints
      ,IncludeNotDiscountable = @IncludeNotDiscountable
      ,IncludePhoneOrder =   @IncludePhoneOrder
      ,PointsSum =   @PointsSum
      ,PointsAmount =   @PointsAmount
      ,PointsPerCoin=@PointsPerCoin
      ,[Status]=@Status
	  ,[DateModified] =@UpdateTime
	  ,[UserModified] = @ModifierID	

 WHERE	[SaleID] = @SaleID AND 
		(DateModified = @DateModified OR DateModified IS NULL)


select @UpdateTime as DateModified
GO
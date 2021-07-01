SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SP_SalesInsert]
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
	@ModifierID uniqueidentifier)

AS

INSERT INTO dbo.Sales
		(   [SaleID]
           ,[SaleNo]
           ,[SaleName]
           ,[FromDate]
           ,[ToDate]
           ,[BuyQty]
           ,[GetQty]
           ,[MaxQty]
           ,[MinTotalAmount]
           ,[MinTotalQty]
           ,[SaleType]
           ,[Price]
           ,[Percentage]
		   ,[AmountLess]
           ,[NoTax]
           ,[Priority]
           ,[AllowMultiSales]
           ,[IsGeneral]
           ,[IsCoupon]
           ,AllItemsPoints
           ,IncludeNotDiscountable
           ,IncludePhoneOrder
           ,PointsSum
           ,PointsAmount
		   ,PointsPerCoin
           ,[Status]
           ,[DateCreated]
           ,[UserCreated]
           ,[DateModified]
           ,[UserModified])
     VALUES
           (@SaleID
           ,@SaleNo
           ,@SaleName
           ,@FromDate
           ,@ToDate
           ,@BuyQty
           ,@GetQty
           ,@MaxQty
           ,@MinTotalAmount
           ,@MinTotalQty
           ,@SaleType
           ,@Price
           ,@Percentage
		   ,@AmountLess
           ,@NoTax
           ,@Priority
           ,@AllowMultiSales
           ,@IsGeneral
           ,@IsCoupon
           ,@AllItemsPoints
           ,@IncludeNotDiscountable
           ,@IncludePhoneOrder
           ,@PointsSum
           ,@PointsAmount
           ,@PointsPerCoin
           ,isnull(@Status,1)
           ,dbo.GetLocalDATE()
           ,@ModifierID
           ,dbo.GetLocalDATE()
           ,@ModifierID)
GO
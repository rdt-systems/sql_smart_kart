﻿CREATE TABLE [dbo].[Sales] (
  [SaleID] [uniqueidentifier] NOT NULL,
  [AllItemsPoints] [bit] NULL,
  [AllowMultiSales] [bit] NULL,
  [AmountLess] [money] NULL,
  [BuyQty] [decimal] NULL,
  [DateCreated] [datetime] NULL,
  [DateModified] [datetime] NULL,
  [FromDate] [datetime] NULL,
  [GetQty] [decimal] NULL,
  [IncludeNotDiscountable] [bit] NULL,
  [IncludePhoneOrder] [bit] NULL,
  [IsCoupon] [bit] NULL,
  [IsGeneral] [bit] NULL,
  [MaxQty] [decimal] NULL,
  [MinTotalAmount] [money] NULL,
  [MinTotalQty] [decimal] NULL,
  [NoTax] [bit] NULL,
  [Percentage] [decimal] NULL,
  [PointsAmount] [int] NULL,
  [PointsPerCoin] [int] NULL,
  [PointsSum] [money] NULL,
  [Price] [money] NULL,
  [Priority] [int] NULL,
  [SaleName] [nvarchar](200) NULL,
  [SaleNo] [nvarchar](50) NULL,
  [SaleConditionsNo] [uniqueidentifier] NULL,
  [SaleType] [int] NULL,
  [Status] [smallint] NULL,
  [ToDate] [datetime] NULL,
  [UserCreated] [uniqueidentifier] NULL,
  [UserModified] [uniqueidentifier] NULL,
  CONSTRAINT [PK_Sales_SaleID] PRIMARY KEY CLUSTERED ([SaleID]) WITH (STATISTICS_NORECOMPUTE = ON)
)
GO
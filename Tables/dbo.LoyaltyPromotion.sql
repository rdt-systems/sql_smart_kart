CREATE TABLE [dbo].[LoyaltyPromotion] (
  [LoyaltyPromotionID] [uniqueidentifier] NOT NULL,
  [Name] [nvarchar](50) NULL,
  [Code] [nvarchar](50) NULL,
  [Points] [int] NULL,
  [ForDolar] [decimal] NULL,
  [IncludeSaleItems] [bit] NULL,
  [IncludeNoDiscountItems] [bit] NULL,
  [InculudeDiscounts] [bit] NULL,
  [FromDate] [datetime] NULL,
  [ToDate] [datetime] NULL,
  [Status] [int] NULL,
  [Item] [int] NULL,
  [Department] [int] NULL,
  [Brand] [int] NULL,
  [Store] [int] NULL,
  [DateCreated] [datetime] NULL,
  [DateModified] [datetime] NULL,
  [UserCreated] [uniqueidentifier] NULL,
  [UserModified] [uniqueidentifier] NULL,
  [AutoAssign] [bit] NULL,
  CONSTRAINT [PK_LoyaltyPromotion] PRIMARY KEY CLUSTERED ([LoyaltyPromotionID]) WITH (STATISTICS_NORECOMPUTE = ON)
)
GO
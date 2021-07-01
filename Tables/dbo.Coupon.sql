CREATE TABLE [dbo].[Coupon] (
  [Amount] [money] NULL,
  [CouponNo] [nvarchar](50) NULL,
  [ExpDate] [datetime] NULL,
  [CouponIssueDate] [datetime] NULL,
  [CouponID] [uniqueidentifier] NOT NULL,
  [CustomerID] [uniqueidentifier] NULL,
  [PurchaseWeek] [datetime] NULL,
  [Status] [int] NULL,
  [Notes] [nvarchar](500) NULL,
  [CouponDate] [datetime] NULL,
  [CouponType] [int] NULL,
  [TransactionID] [uniqueidentifier] NULL,
  [DateModified] [datetime] NULL,
  [UserModified] [uniqueidentifier] NULL,
  [VoidReason] [nvarchar](100) NULL,
  [DateCreated] [datetime] NULL,
  CONSTRAINT [PK_Coupon] PRIMARY KEY CLUSTERED ([CouponID]) WITH (STATISTICS_NORECOMPUTE = ON),
  CONSTRAINT [CK__Coupon__CouponNo__4D211CFD] CHECK (datalength([CouponNo])>(0))
)
GO

CREATE INDEX [Coupon_IX1]
  ON [dbo].[Coupon] ([TransactionID])
  WITH (STATISTICS_NORECOMPUTE = ON)
GO

CREATE INDEX [IX_Coupon_CouponNo_Status]
  ON [dbo].[Coupon] ([CouponNo], [Status])
  WITH (STATISTICS_NORECOMPUTE = ON)
GO
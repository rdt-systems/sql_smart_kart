CREATE TABLE [dbo].[CouponUsed] (
  [Amount] [money] NULL,
  [CouponID] [uniqueidentifier] NULL,
  [CouponUsedID] [uniqueidentifier] NOT NULL,
  [DateCreated] [datetime] NULL,
  [Status] [int] NULL,
  [TransactionID] [uniqueidentifier] NULL,
  [UsedDate] [datetime] NULL,
  [DateModified] [datetime] NULL,
  [AmountAdd] [money] NULL,
  CONSTRAINT [PK_CouponUsed] PRIMARY KEY CLUSTERED ([CouponUsedID]) WITH (STATISTICS_NORECOMPUTE = ON),
  CONSTRAINT [IX_CouponUsed] UNIQUE ([CouponUsedID]) WITH (STATISTICS_NORECOMPUTE = ON)
)
GO

CREATE INDEX [CouponUsed_IX1]
  ON [dbo].[CouponUsed] ([TransactionID])
  INCLUDE ([Amount])
  WITH (STATISTICS_NORECOMPUTE = ON)
GO

CREATE INDEX [IX_CouponUsed_CouponID_Status]
  ON [dbo].[CouponUsed] ([CouponID], [Status])
  WITH (STATISTICS_NORECOMPUTE = ON)
GO
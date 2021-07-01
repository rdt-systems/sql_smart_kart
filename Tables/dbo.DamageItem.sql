CREATE TABLE [dbo].[DamageItem] (
  [DamageItemID] [uniqueidentifier] NOT NULL,
  [ItemStoreID] [uniqueidentifier] NULL,
  [Qty] [decimal](19, 3) NULL,
  [DamageStatus] [int] NULL,
  [TransactionEntryID] [uniqueidentifier] NULL,
  [ReturnEntryID] [uniqueidentifier] NULL,
  [Date] [datetime] NULL,
  [Status] [int] NULL,
  [DateCreated] [datetime] NULL,
  [UserCreated] [uniqueidentifier] NULL,
  [DateModified] [datetime] NULL,
  [UserModified] [uniqueidentifier] NULL,
  CONSTRAINT [PK_DamageItems] PRIMARY KEY CLUSTERED ([DamageItemID]) WITH (STATISTICS_NORECOMPUTE = ON)
)
GO

CREATE INDEX [IX_QuickReport_1]
  ON [dbo].[DamageItem] ([DamageStatus], [Status])
  INCLUDE ([Qty], [TransactionEntryID], [Date])
  WITH (STATISTICS_NORECOMPUTE = ON)
GO
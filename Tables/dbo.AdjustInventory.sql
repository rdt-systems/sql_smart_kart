CREATE TABLE [dbo].[AdjustInventory] (
  [AdjustInventoryId] [uniqueidentifier] NOT NULL,
  [ItemStoreNo] [uniqueidentifier] NULL,
  [AdjustType] [int] NULL,
  [Qty] [decimal](19, 3) NULL,
  [OldQty] [decimal] NULL,
  [AdjustReason] [nvarchar](4000) NULL,
  [AccountNo] [int] NULL,
  [Cost] [money] NULL,
  [Status] [smallint] NULL,
  [DateCreated] [datetime] NULL CONSTRAINT [DateCreated] DEFAULT (getdate()),
  [UserCreated] [uniqueidentifier] NULL,
  [DateModified] [datetime] NULL,
  [UserModified] [uniqueidentifier] NULL,
  CONSTRAINT [PK_AdjustInventory] PRIMARY KEY CLUSTERED ([AdjustInventoryId]) WITH (STATISTICS_NORECOMPUTE = ON)
)
GO

CREATE INDEX [AdjustInventory_ix1]
  ON [dbo].[AdjustInventory] ([DateModified])
  INCLUDE ([AdjustInventoryId], [ItemStoreNo], [Qty], [OldQty], [UserCreated])
  WITH (STATISTICS_NORECOMPUTE = ON)
GO

CREATE INDEX [IX_AdjustInventory_ItemStoreNo_Status_DateCreated]
  ON [dbo].[AdjustInventory] ([ItemStoreNo], [Status], [DateCreated])
  WITH (STATISTICS_NORECOMPUTE = ON)
GO

CREATE INDEX [IX_AdjustInventory_Speed_001]
  ON [dbo].[AdjustInventory] ([ItemStoreNo])
  WITH (STATISTICS_NORECOMPUTE = ON)
GO

CREATE INDEX [IX_QuickReport_3]
  ON [dbo].[AdjustInventory] ([Status])
  INCLUDE ([AdjustType], [Qty], [DateCreated], [UserCreated])
  WITH (STATISTICS_NORECOMPUTE = ON)
GO

CREATE INDEX [IX_QuickReport_7]
  ON [dbo].[AdjustInventory] ([Status])
  INCLUDE ([ItemStoreNo], [AdjustType], [Qty], [DateCreated], [UserCreated])
  WITH (STATISTICS_NORECOMPUTE = ON)
GO
CREATE TABLE [dbo].[AllocateItems] (
  [AllocateID] [int] IDENTITY,
  [OrderID] [uniqueidentifier] NULL,
  [ItemStoreID] [uniqueidentifier] NULL,
  [StoreID] [uniqueidentifier] NULL,
  [QTY] [decimal] NULL,
  [Status] [int] NULL,
  [DateCreated] [datetime] NULL,
  [DateModified] [datetime] NULL,
  [OrderCreated] [int] NULL CONSTRAINT [DF__AllocateI__Order__3E34AA7F] DEFAULT (0),
  [TransferEntryID] [uniqueidentifier] NULL,
  CONSTRAINT [PK__Allocate__461A3FDF6403B6FE] PRIMARY KEY CLUSTERED ([AllocateID]) WITH (STATISTICS_NORECOMPUTE = ON)
)
GO

CREATE INDEX [IX_AllocateItems_Speed_00000000003]
  ON [dbo].[AllocateItems] ([Status])
  INCLUDE ([OrderID], [ItemStoreID], [StoreID], [QTY])
  WITH (STATISTICS_NORECOMPUTE = ON)
GO

CREATE INDEX [IX_AllocateItems_Speed_0000002]
  ON [dbo].[AllocateItems] ([Status])
  INCLUDE ([OrderID], [QTY])
  WITH (STATISTICS_NORECOMPUTE = ON)
GO

CREATE INDEX [IX_AllocateItems_Speed_00001]
  ON [dbo].[AllocateItems] ([OrderID])
  INCLUDE ([StoreID], [QTY], [Status])
  WITH (STATISTICS_NORECOMPUTE = ON)
GO

CREATE INDEX [nci_wi_AllocateItems_2DAFD4E94ECE9D4D264C807D51BF6E6F]
  ON [dbo].[AllocateItems] ([StoreID], [Status])
  WITH (STATISTICS_NORECOMPUTE = ON)
GO
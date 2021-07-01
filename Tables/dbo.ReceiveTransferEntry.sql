CREATE TABLE [dbo].[ReceiveTransferEntry] (
  [ReceiveTranferEntryID] [uniqueidentifier] NOT NULL,
  [ReceiveTransferID] [uniqueidentifier] NULL,
  [ItemStoreID] [uniqueidentifier] NULL,
  [TransferEntryID] [uniqueidentifier] NULL,
  [Qty] [decimal] NULL,
  [UOMQty] [decimal] NULL,
  [UOMType] [int] NULL,
  [DateCreate] [datetime] NULL,
  [DateModified] [datetime] NULL,
  [UserCreate] [uniqueidentifier] NULL,
  [UserModified] [uniqueidentifier] NULL,
  [Status] [int] NULL,
  [Cost] [decimal] NULL,
  CONSTRAINT [PK_ReceiveTransferEntry] PRIMARY KEY CLUSTERED ([ReceiveTranferEntryID]) WITH (STATISTICS_NORECOMPUTE = ON)
)
GO

CREATE INDEX [IX_QuickReport_5]
  ON [dbo].[ReceiveTransferEntry] ([Status])
  INCLUDE ([ReceiveTransferID], [Qty], [UOMType], [UserCreate])
  WITH (STATISTICS_NORECOMPUTE = ON)
GO

CREATE INDEX [IX_ReceiveTransferEntry_ItemStoreID_DateCreate_Status]
  ON [dbo].[ReceiveTransferEntry] ([ItemStoreID], [DateCreate], [Status])
  WITH (STATISTICS_NORECOMPUTE = ON)
GO

CREATE INDEX [IX_ReceiveTransferEntry_PendingOrders_001]
  ON [dbo].[ReceiveTransferEntry] ([Status])
  INCLUDE ([ReceiveTransferID], [TransferEntryID], [Qty])
  WITH (STATISTICS_NORECOMPUTE = ON)
GO

CREATE INDEX [IX_ReceiveTransferEntry_PendingOrders_002]
  ON [dbo].[ReceiveTransferEntry] ([ReceiveTransferID], [Status])
  INCLUDE ([TransferEntryID])
  WITH (STATISTICS_NORECOMPUTE = ON)
GO
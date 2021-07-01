CREATE TABLE [dbo].[ReceiveEntry] (
  [ReceiveEntryID] [uniqueidentifier] NOT NULL,
  [ReceiveNo] [uniqueidentifier] NULL,
  [ItemStoreNo] [uniqueidentifier] NULL,
  [PurchaseOrderEntryNo] [uniqueidentifier] NULL,
  [Cost] [money] NULL,
  [Qty] [decimal](18, 2) NULL,
  [UOMQty] [decimal](18, 2) NULL,
  [UOMType] [int] NULL,
  [ExtPrice] [money] NULL,
  [IsSpecialPrice] [bit] NULL,
  [ForApprove] [bit] NULL,
  [LinkNo] [uniqueidentifier] NULL,
  [Note] [nvarchar](4000) NULL,
  [SortOrder] [int] NULL,
  [Taxable] [bit] NULL,
  [Status] [smallint] NULL,
  [DateCreated] [datetime] NULL,
  [UserCreated] [uniqueidentifier] NULL,
  [DateModified] [datetime] NULL,
  [UserModified] [uniqueidentifier] NULL,
  [ListPrice] [money] NULL CONSTRAINT [DF_ReceiveEntry_ListPrice] DEFAULT (0),
  [Margin] [money] NULL CONSTRAINT [DF_ReceiveEntry_Margin] DEFAULT (0),
  [Markup] [money] NULL CONSTRAINT [DF_ReceiveEntry_Markup] DEFAULT (0),
  [NetCost] [money] NULL,
  [CaseCost] [money] NULL,
  [PcCost] [money] NULL,
  [CaseQty] [decimal](18, 1) NULL,
  [PriceStatus] [tinyint] NULL,
  [LastNetCost] [money] NULL,
  [UOMPrice] [money] NULL,
  [EstimatedPrice] [money] NULL,
  [Discount] [money] NULL,
  [DiscountType] [int] NULL,
  [NetPcCost] [money] NULL,
  [PackingSlipLineNo] [nvarchar](100) NULL,
  CONSTRAINT [PK_ReceiveEntry] PRIMARY KEY CLUSTERED ([ReceiveEntryID]) WITH (STATISTICS_NORECOMPUTE = ON)
)
GO

CREATE INDEX [Ix_POs_OpenCount]
  ON [dbo].[ReceiveEntry] ([Status])
  INCLUDE ([PurchaseOrderEntryNo], [Qty])
  WITH (STATISTICS_NORECOMPUTE = ON)
GO

CREATE INDEX [IX_PurchaseOrderEntryNo_Status]
  ON [dbo].[ReceiveEntry] ([PurchaseOrderEntryNo], [Status])
  WITH (STATISTICS_NORECOMPUTE = ON)
GO

CREATE INDEX [IX_QuickReport_2]
  ON [dbo].[ReceiveEntry] ([Status])
  INCLUDE ([ReceiveNo], [Qty], [UOMType])
  WITH (STATISTICS_NORECOMPUTE = ON)
GO

CREATE INDEX [IX_QuickReport_6]
  ON [dbo].[ReceiveEntry] ([Status])
  INCLUDE ([ReceiveNo], [ItemStoreNo], [Qty], [UOMType])
  WITH (STATISTICS_NORECOMPUTE = ON)
GO

CREATE INDEX [IX_ReceiveEntry_Dashboard02]
  ON [dbo].[ReceiveEntry] ([Status])
  INCLUDE ([PurchaseOrderEntryNo], [UOMQty])
  WITH (STATISTICS_NORECOMPUTE = ON)
GO

CREATE INDEX [IX_ReceiveEntry_MYPTD_Speed_00001]
  ON [dbo].[ReceiveEntry] ([Status])
  INCLUDE ([ReceiveNo], [ItemStoreNo], [UOMQty], [UserCreated])
  WITH (STATISTICS_NORECOMPUTE = ON)
GO

CREATE INDEX [IX_ReceiveEntry_Speed_001]
  ON [dbo].[ReceiveEntry] ([Status])
  INCLUDE ([ReceiveNo], [ItemStoreNo], [Qty], [NetCost], [CaseQty])
  WITH (STATISTICS_NORECOMPUTE = ON)
GO

CREATE INDEX [IX_ReceiveEntryView_Index_Speed]
  ON [dbo].[ReceiveEntry] ([ItemStoreNo], [Status])
  INCLUDE ([ReceiveNo], [PurchaseOrderEntryNo], [Cost], [Qty], [UOMQty], [UOMType], [ExtPrice], [IsSpecialPrice], [ForApprove], [LinkNo], [Note], [SortOrder], [Taxable], [DateCreated], [UserCreated], [DateModified], [UserModified], [ListPrice], [NetCost], [CaseCost], [PcCost], [CaseQty], [PriceStatus], [LastNetCost], [Discount], [NetPcCost])
  WITH (STATISTICS_NORECOMPUTE = ON)
GO

CREATE INDEX [IX_Receives_Speed_001]
  ON [dbo].[ReceiveEntry] ([Status])
  INCLUDE ([PurchaseOrderEntryNo], [Qty], [UOMType], [CaseQty])
  WITH (STATISTICS_NORECOMPUTE = ON)
GO

CREATE INDEX [ReceiveEntry_IX1]
  ON [dbo].[ReceiveEntry] ([ReceiveNo])
  INCLUDE ([ItemStoreNo], [Status])
  WITH (STATISTICS_NORECOMPUTE = ON)
GO
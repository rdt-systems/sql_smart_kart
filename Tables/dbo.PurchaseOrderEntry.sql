CREATE TABLE [dbo].[PurchaseOrderEntry] (
  [PurchaseOrderEntryId] [uniqueidentifier] NOT NULL,
  [PurchaseOrderNo] [uniqueidentifier] NOT NULL,
  [ItemNo] [uniqueidentifier] NULL,
  [QtyOrdered] [decimal](19, 3) NULL,
  [PricePerUnit] [money] NULL,
  [UOMQty] [int] NULL,
  [UOMType] [int] NULL,
  [ExtPrice] [money] NULL,
  [IsSpecialPrice] [bit] NULL,
  [LinkNo] [uniqueidentifier] NULL,
  [Note] [nvarchar](4000) NULL,
  [SortOrder] [int] NULL,
  [Status] [smallint] NULL,
  [DateCreated] [datetime] NULL,
  [UserCreated] [uniqueidentifier] NULL,
  [DateModified] [datetime] NULL,
  [UserModified] [uniqueidentifier] NULL,
  [CostBeforeDis] [money] NULL,
  [EstimateCost] [money] NULL,
  [NetCost] [money] NULL,
  [SpecialCost] [money] NULL,
  [Discount] [money] NULL,
  [DiscountType] [int] NULL,
  CONSTRAINT [PK_PurchaseOrderEntry] PRIMARY KEY CLUSTERED ([PurchaseOrderEntryId])
)
GO

CREATE INDEX [IX_PurchaseOrderEntry_ItemNo]
  ON [dbo].[PurchaseOrderEntry] ([ItemNo])
GO

CREATE INDEX [IX_PurchaseOrderEntry_Speed_00001]
  ON [dbo].[PurchaseOrderEntry] ([PurchaseOrderNo], [Status])
  INCLUDE ([ItemNo], [QtyOrdered])
GO

CREATE INDEX [IX_PurchaseOrderEntry_Speed_PO_005]
  ON [dbo].[PurchaseOrderEntry] ([Status])
  INCLUDE ([PurchaseOrderNo], [ItemNo], [UOMQty])
GO

CREATE INDEX [IX_PurchaseOrderEntry_Speed_PO_006]
  ON [dbo].[PurchaseOrderEntry] ([PurchaseOrderNo], [Status])
  INCLUDE ([ItemNo], [UOMQty])
GO

CREATE INDEX [IX_PurchaseOrderNo_Status]
  ON [dbo].[PurchaseOrderEntry] ([PurchaseOrderNo], [Status])
GO

CREATE INDEX [nci_wi_PurchaseOrderEntry_F737EB38ACCC41D0CEC7621991B20448]
  ON [dbo].[PurchaseOrderEntry] ([PurchaseOrderNo], [Status])
GO

CREATE INDEX [POLoads]
  ON [dbo].[PurchaseOrderEntry] ([Status])
  INCLUDE ([QtyOrdered], [PurchaseOrderNo], [PurchaseOrderEntryId])
GO

CREATE INDEX [POLoads2]
  ON [dbo].[PurchaseOrderEntry] ([PurchaseOrderNo], [Status])
  INCLUDE ([QtyOrdered], [PurchaseOrderEntryId])
GO

ALTER TABLE [dbo].[PurchaseOrderEntry]
  ADD CONSTRAINT [FK_PurchaseOrderEntry_PurchaseOrders] FOREIGN KEY ([PurchaseOrderNo]) REFERENCES [dbo].[PurchaseOrders] ([PurchaseOrderId])
GO
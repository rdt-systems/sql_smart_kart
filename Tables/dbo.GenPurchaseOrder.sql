CREATE TABLE [dbo].[GenPurchaseOrder] (
  [GenPurchaseOrderID] [uniqueidentifier] NOT NULL,
  [DateCreated] [datetime] NULL,
  [DateModified] [datetime] NULL,
  [ItemNo] [uniqueidentifier] NULL,
  [ReorderQty] [decimal](19, 2) NULL,
  [Status] [smallint] NULL,
  [Supplier] [uniqueidentifier] NULL,
  [ToOrder] [bit] NULL,
  [UOMType] [int] NULL,
  [SortOrder] [int] NULL,
  [StoreID] [uniqueidentifier] NULL,
  [UserModified] [uniqueidentifier] NULL,
  CONSTRAINT [PK_GenPurchaseOrder] PRIMARY KEY CLUSTERED ([GenPurchaseOrderID])
)
GO
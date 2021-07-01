CREATE TABLE [dbo].[WorkOrderEntry] (
  [WorkOrderEntryID] [uniqueidentifier] NOT NULL,
  [WorkOrderID] [uniqueidentifier] NULL,
  [ItemStoreID] [uniqueidentifier] NULL,
  [Sort] [smallint] NULL,
  [Taxable] [bit] NULL,
  [UOMQty] [decimal](19, 3) NULL,
  [Qty] [decimal](19, 3) NULL,
  [Price] [money] NULL,
  [UOMType] [int] NULL,
  [PriceExplanation] [nvarchar](50) NULL,
  [ParentTransactionEntry] [uniqueidentifier] NULL,
  [Note] [nvarchar](50) NULL,
  [Status] [smallint] NULL,
  [DateCreated] [datetime] NULL,
  [UserCreated] [uniqueidentifier] NULL,
  [DateModified] [datetime] NULL,
  [UserModified] [uniqueidentifier] NULL,
  CONSTRAINT [PK__WorkOrderEntry__44AB0736] PRIMARY KEY CLUSTERED ([WorkOrderEntryID])
)
GO
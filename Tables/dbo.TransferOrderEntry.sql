CREATE TABLE [dbo].[TransferOrderEntry] (
  [TransferOrderEntryID] [uniqueidentifier] NOT NULL,
  [TransferOrderID] [uniqueidentifier] NULL,
  [ItemStoreNo] [uniqueidentifier] NULL,
  [Qty] [decimal] NULL,
  [UOMQty] [decimal] NULL,
  [UOMType] [int] NULL,
  [UOMPrice] [money] NULL,
  [LinkNo] [uniqueidentifier] NULL,
  [Note] [nvarchar](4000) NULL,
  [SortOrder] [int] NULL,
  [Status] [smallint] NULL,
  [DateCreated] [datetime] NULL,
  [UserCreated] [uniqueidentifier] NULL,
  [DateModified] [datetime] NULL,
  [UserModified] [uniqueidentifier] NULL,
  PRIMARY KEY CLUSTERED ([TransferOrderEntryID])
)
GO
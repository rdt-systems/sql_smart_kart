CREATE TABLE [dbo].[ItemNotExistsOtherStore] (
  [BarcodeNumber] [varchar](100) NULL,
  [FromDb] [varchar](100) NULL,
  [Todb] [varchar](100) NULL,
  [Qty] [decimal] NULL,
  [PhoneOrderID] [uniqueidentifier] NULL,
  [ItemStoreID] [uniqueidentifier] NULL
)
GO
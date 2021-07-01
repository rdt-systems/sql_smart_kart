CREATE TABLE [dbo].[itemStoreOnHandAvgCustHistory] (
  [ItemStoreId] [uniqueidentifier] NOT NULL,
  [ItemNo] [uniqueidentifier] NULL,
  [AVGCost] [money] NULL,
  [OnHand] [decimal] NULL,
  [PcCost] [money] NULL,
  [Qty] [decimal] NULL,
  [DateModified] [datetime] NULL
)
GO
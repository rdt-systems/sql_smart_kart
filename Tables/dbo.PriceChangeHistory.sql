CREATE TABLE [dbo].[PriceChangeHistory] (
  [PriceChangeHistoryID] [uniqueidentifier] NOT NULL,
  [ItemStoreID] [uniqueidentifier] NULL,
  [PriceLevel] [nvarchar](50) NULL,
  [OldPrice] [money] NULL,
  [NewPrice] [money] NULL,
  [UserID] [uniqueidentifier] NULL,
  [SaleType] [nvarchar](50) NULL,
  [SP_Price] [nvarchar](50) NULL,
  [SaleDate] [nvarchar](50) NULL,
  [Date] [datetime] NULL,
  [DateCreated] [datetime] NULL,
  [DateModified] [datetime] NULL,
  [status] [smallint] NULL,
  CONSTRAINT [PK_PriceChangeHistory] PRIMARY KEY CLUSTERED ([PriceChangeHistoryID]) WITH (STATISTICS_NORECOMPUTE = ON)
)
GO

CREATE INDEX [IX_PriceChangeHistory_ItemStoreID]
  ON [dbo].[PriceChangeHistory] ([ItemStoreID])
  WITH (STATISTICS_NORECOMPUTE = ON)
GO

ALTER TABLE [dbo].[PriceChangeHistory]
  ADD CONSTRAINT [FK_PriceChangeHistory_ItemStore] FOREIGN KEY ([ItemStoreID]) REFERENCES [dbo].[ItemStore] ([ItemStoreID])
GO
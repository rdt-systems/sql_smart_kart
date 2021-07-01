CREATE TABLE [dbo].[SeasonHistory] (
  [SeasonHistoryId] [uniqueidentifier] NOT NULL,
  [StoreId] [uniqueidentifier] NOT NULL,
  [ItemId] [uniqueidentifier] NOT NULL,
  [ItemStoreId] [uniqueidentifier] NOT NULL,
  [OldSeasonId] [uniqueidentifier] NULL,
  [NewSeasonId] [uniqueidentifier] NOT NULL,
  [Onhand] [int] NOT NULL,
  [Cost] [money] NULL,
  [DateCreated] [datetime] NOT NULL,
  [UserCreated] [uniqueidentifier] NOT NULL,
  CONSTRAINT [PK_SeasonHistory] PRIMARY KEY CLUSTERED ([SeasonHistoryId]) WITH (STATISTICS_NORECOMPUTE = ON)
)
GO

CREATE INDEX [IX_SeasonHistory]
  ON [dbo].[SeasonHistory] ([ItemStoreId])
  WITH (STATISTICS_NORECOMPUTE = ON)
GO
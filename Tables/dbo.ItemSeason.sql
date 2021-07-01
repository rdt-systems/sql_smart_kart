CREATE TABLE [dbo].[ItemSeason] (
  [ItemStoreSeasonId] [uniqueidentifier] NOT NULL,
  [ItemStoreNo] [uniqueidentifier] NULL,
  [SeasonNo] [uniqueidentifier] NULL,
  [Status] [smallint] NULL,
  [DateModified] [datetime] NULL,
  CONSTRAINT [PK_ItemSeason] PRIMARY KEY CLUSTERED ([ItemStoreSeasonId])
)
GO
CREATE TABLE [dbo].[GiftRegisteryEntry] (
  [GiftRegisteryEntryID] [uniqueidentifier] NOT NULL,
  [GiftRegisteryID] [uniqueidentifier] NOT NULL,
  [ItemID] [uniqueidentifier] NULL,
  [QtyRequested] [int] NULL,
  [QtyReceived] [int] NULL,
  [DateCreated] [datetime] NULL,
  [DateModified] [datetime] NULL,
  [Status] [int] NULL,
  CONSTRAINT [PK_GiftRegisteryEntry] PRIMARY KEY CLUSTERED ([GiftRegisteryEntryID]) WITH (STATISTICS_NORECOMPUTE = ON)
)
GO

CREATE INDEX [IX_GiftRegisteryEntryID]
  ON [dbo].[GiftRegisteryEntry] ([GiftRegisteryID])
  WITH (STATISTICS_NORECOMPUTE = ON)
GO
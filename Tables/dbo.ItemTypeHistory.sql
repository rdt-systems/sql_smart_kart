CREATE TABLE [dbo].[ItemTypeHistory] (
  [HistID] [int] IDENTITY,
  [OldItemType] [int] NULL,
  [NewItemType] [int] NULL,
  [DateChanged] [datetime] NULL,
  [UserChanged] [uniqueidentifier] NULL,
  [ItemID] [uniqueidentifier] NOT NULL,
  CONSTRAINT [PK_ItemTypeHistory] PRIMARY KEY CLUSTERED ([HistID]) WITH (STATISTICS_NORECOMPUTE = ON)
)
GO
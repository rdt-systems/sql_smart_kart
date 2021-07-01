CREATE TABLE [dbo].[ItemStoreIDs] (
  [ItemStoreID] [uniqueidentifier] NOT NULL,
  [ItemID] [uniqueidentifier] NULL,
  [UserID] [uniqueidentifier] NULL,
  PRIMARY KEY CLUSTERED ([ItemStoreID]) WITH (STATISTICS_NORECOMPUTE = ON)
)
GO
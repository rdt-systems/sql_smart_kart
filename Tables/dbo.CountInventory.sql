CREATE TABLE [dbo].[CountInventory] (
  [CountInventoryID] [int] IDENTITY,
  [UserID] [uniqueidentifier] NULL,
  [CountDate] [datetime] NULL,
  [StoreID] [uniqueidentifier] NULL,
  [Status] [int] NULL,
  [DateCreated] [datetime] NULL,
  [DateModified] [datetime] NULL,
  [CountID] [uniqueidentifier] NULL,
  CONSTRAINT [PK__CountInv__A82004F041E3A924] PRIMARY KEY CLUSTERED ([CountInventoryID]) WITH (STATISTICS_NORECOMPUTE = ON)
)
GO

CREATE UNIQUE INDEX [IX_CountInventory]
  ON [dbo].[CountInventory] ([CountID])
  WHERE ([Status]>(-1) AND [CountID] IS NOT NULL)
  WITH (STATISTICS_NORECOMPUTE = ON)
GO
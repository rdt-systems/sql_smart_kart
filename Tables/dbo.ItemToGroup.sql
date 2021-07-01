CREATE TABLE [dbo].[ItemToGroup] (
  [ItemToGroupID] [uniqueidentifier] NOT NULL,
  [ItemGroupID] [uniqueidentifier] NULL,
  [ItemStoreID] [uniqueidentifier] NULL,
  [Status] [smallint] NULL,
  [DateModified] [datetime] NULL,
  CONSTRAINT [PK_ItemToGroup] PRIMARY KEY CLUSTERED ([ItemToGroupID])
)
GO

CREATE INDEX [_dta_index_ItemToGroup_5_290100074__K3_K2_4]
  ON [dbo].[ItemToGroup] ([ItemStoreID], [ItemGroupID])
  INCLUDE ([Status])
GO

CREATE INDEX [IX_ItemToGroup_ItemGroupID_Status]
  ON [dbo].[ItemToGroup] ([ItemGroupID], [Status])
  INCLUDE ([DateModified], [ItemStoreID])
GO

CREATE INDEX [IX_ItemToGroup_Status_DateModified]
  ON [dbo].[ItemToGroup] ([Status], [DateModified])
  INCLUDE ([ItemGroupID], [ItemStoreID])
GO

ALTER TABLE [dbo].[ItemToGroup] WITH NOCHECK
  ADD CONSTRAINT [FK_ItemToGroup_ItemGroup] FOREIGN KEY ([ItemGroupID]) REFERENCES [dbo].[ItemGroup] ([ItemGroupID])
GO

ALTER TABLE [dbo].[ItemToGroup] WITH NOCHECK
  ADD CONSTRAINT [FK_ItemToGroup_ItemStore] FOREIGN KEY ([ItemStoreID]) REFERENCES [dbo].[ItemStore] ([ItemStoreID])
GO
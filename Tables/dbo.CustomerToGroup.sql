CREATE TABLE [dbo].[CustomerToGroup] (
  [CustomerToGroupID] [uniqueidentifier] NOT NULL,
  [CustomerGroupID] [uniqueidentifier] NOT NULL,
  [CustomerID] [uniqueidentifier] NOT NULL,
  [Status] [smallint] NULL,
  [DateModified] [datetime] NULL,
  CONSTRAINT [PK_CustomerToGroup_1] PRIMARY KEY CLUSTERED ([CustomerToGroupID]) WITH (STATISTICS_NORECOMPUTE = ON)
)
GO

CREATE INDEX [_dta_index_CustomerToGroup_5_206623779__K2_K3]
  ON [dbo].[CustomerToGroup] ([CustomerGroupID], [CustomerID])
  WITH (STATISTICS_NORECOMPUTE = ON)
GO

CREATE UNIQUE INDEX [IX_CustomerToGrou]
  ON [dbo].[CustomerToGroup] ([CustomerID], [CustomerToGroupID], [Status])
  INCLUDE ([CustomerGroupID])
  WITH (STATISTICS_NORECOMPUTE = ON)
GO

CREATE UNIQUE INDEX [missing_index_4_3_CustomerToGroup]
  ON [dbo].[CustomerToGroup] ([CustomerID], [CustomerToGroupID])
  INCLUDE ([CustomerGroupID])
  WITH (STATISTICS_NORECOMPUTE = ON)
GO
CREATE TABLE [dbo].[CustomerToEmail] (
  [CustomerToEmailID] [uniqueidentifier] NOT NULL,
  [CustomerID] [uniqueidentifier] NULL,
  [EmailID] [uniqueidentifier] NULL,
  [Status] [smallint] NULL,
  [DateModified] [datetime] NULL,
  PRIMARY KEY CLUSTERED ([CustomerToEmailID]) WITH (STATISTICS_NORECOMPUTE = ON)
)
GO

CREATE INDEX [IX_CustomerToEmail]
  ON [dbo].[CustomerToEmail] ([CustomerID], [EmailID])
  WITH (STATISTICS_NORECOMPUTE = ON)
GO
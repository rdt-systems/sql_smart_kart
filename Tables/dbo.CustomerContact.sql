CREATE TABLE [dbo].[CustomerContact] (
  [CustomerContactID] [uniqueidentifier] NOT NULL,
  [CustomerID] [uniqueidentifier] NULL,
  [FirstName] [nvarchar](50) NULL,
  [LastName] [nvarchar](50) NULL,
  [SortOrder] [smallint] NULL,
  [Password] [nvarchar](50) NULL,
  [CardMember] [nvarchar](50) NULL,
  [Phone1] [nvarchar](20) NULL,
  [Phone2] [nvarchar](20) NULL,
  [Emeil] [nvarchar](20) NULL,
  [Status] [smallint] NULL,
  [DateModified] [datetime] NULL,
  PRIMARY KEY CLUSTERED ([CustomerContactID])
)
GO

CREATE INDEX [IX_CustomerContact]
  ON [dbo].[CustomerContact] ([CustomerID])
GO
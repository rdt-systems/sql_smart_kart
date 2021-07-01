CREATE TABLE [dbo].[SupplierContact] (
  [SuplierContactID] [uniqueidentifier] NOT NULL,
  [SupplierNo] [uniqueidentifier] NULL,
  [ContactNo] [uniqueidentifier] NULL,
  [JobTitle] [nvarchar](20) NULL,
  [Department] [nvarchar](50) NULL,
  [Description] [nvarchar](4000) NULL,
  [SortOrder] [smallint] NULL,
  [Status] [smallint] NULL,
  [DateModified] [datetime] NULL,
  PRIMARY KEY CLUSTERED ([SuplierContactID])
)
GO
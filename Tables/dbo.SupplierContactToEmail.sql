CREATE TABLE [dbo].[SupplierContactToEmail] (
  [SupplierContactToEmaillID] [uniqueidentifier] NOT NULL,
  [ContactID] [uniqueidentifier] NULL,
  [EmailID] [uniqueidentifier] NULL,
  [Status] [smallint] NULL,
  [DateModified] [datetime] NULL,
  PRIMARY KEY CLUSTERED ([SupplierContactToEmaillID])
)
GO
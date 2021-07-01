CREATE TABLE [dbo].[SupplierContactToPhone] (
  [SupplierContactToPhoneID] [uniqueidentifier] NOT NULL,
  [ContactID] [uniqueidentifier] NULL,
  [PhoneID] [uniqueidentifier] NULL,
  [Status] [smallint] NULL,
  [DateModified] [datetime] NULL,
  PRIMARY KEY CLUSTERED ([SupplierContactToPhoneID])
)
GO
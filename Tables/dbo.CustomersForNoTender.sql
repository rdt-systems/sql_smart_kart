CREATE TABLE [dbo].[CustomersForNoTender] (
  [CustomerId] [uniqueidentifier] NOT NULL,
  [CustomersForNoTenderID] [uniqueidentifier] NOT NULL,
  [DateCreated] [datetime] NULL,
  [DateModified] [datetime] NULL,
  [Status] [smallint] NULL,
  [TenderId] [int] NULL,
  [UserCreated] [uniqueidentifier] NULL,
  [UserModified] [uniqueidentifier] NULL,
  PRIMARY KEY CLUSTERED ([CustomersForNoTenderID])
)
GO

CREATE INDEX [IX_CustomersForNoTender]
  ON [dbo].[CustomersForNoTender] ([CustomerId], [TenderId])
GO
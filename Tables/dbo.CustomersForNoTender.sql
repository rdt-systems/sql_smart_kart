CREATE TABLE [dbo].[CustomersForNoTender] (
  [CustomerId] [uniqueidentifier] NOT NULL,
  [CustomersForNoTenderID] [uniqueidentifier] NOT NULL,
  [DateCreated] [datetime] NULL,
  [DateModified] [datetime] NULL,
  [Status] [smallint] NULL,
  [TenderId] [int] NULL,
  [UserCreated] [uniqueidentifier] NULL,
  [UserModified] [uniqueidentifier] NULL,
  PRIMARY KEY CLUSTERED ([CustomersForNoTenderID]) WITH (STATISTICS_NORECOMPUTE = ON)
)
GO

CREATE INDEX [IX_CustomersForNoTender]
  ON [dbo].[CustomersForNoTender] ([CustomerId], [TenderId])
  WITH (STATISTICS_NORECOMPUTE = ON)
GO
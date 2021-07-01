CREATE TABLE [dbo].[ReceiveToSale] (
  [TransactionEntryID] [uniqueidentifier] NOT NULL,
  [ReceiveEntryID] [char](10) NULL,
  [Qty] [decimal] NULL,
  [Status] [smallint] NULL,
  [DateCreated] [datetime] NULL,
  [UserCreated] [uniqueidentifier] NULL,
  [DateModified] [datetime] NULL,
  [UserModified] [uniqueidentifier] NULL,
  PRIMARY KEY CLUSTERED ([TransactionEntryID]) WITH (STATISTICS_NORECOMPUTE = ON)
)
GO
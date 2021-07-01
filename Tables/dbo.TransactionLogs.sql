CREATE TABLE [dbo].[TransactionLogs] (
  [TransLogID] [int] IDENTITY,
  [TransactionID] [uniqueidentifier] NULL,
  [OldCustomerID] [uniqueidentifier] NULL,
  [OldRecipt] [ntext] NULL,
  [ChangeLogs] [ntext] NULL,
  [Status] [smallint] NULL,
  [DateCreated] [datetime] NULL,
  [UserCreated] [uniqueidentifier] NULL
)
GO
CREATE TABLE [dbo].[ReturnItem] (
  [ReturnItemID] [uniqueidentifier] NOT NULL,
  [TransactionEntryID] [uniqueidentifier] NULL,
  [SaleEntryID] [uniqueidentifier] NULL,
  [ReturnReason] [nvarchar](4000) NULL,
  [ReturnedStateType] [int] NULL,
  [Status] [smallint] NULL,
  [DateCreated] [datetime] NULL,
  [UserCreated] [uniqueidentifier] NULL,
  [DateModified] [datetime] NULL,
  [UserModified] [uniqueidentifier] NULL,
  PRIMARY KEY CLUSTERED ([ReturnItemID])
)
GO
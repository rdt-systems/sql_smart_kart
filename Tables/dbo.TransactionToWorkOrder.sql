CREATE TABLE [dbo].[TransactionToWorkOrder] (
  [WorkOrderID] [uniqueidentifier] NOT NULL,
  [TransactionEntryID] [uniqueidentifier] NOT NULL,
  [Qty] [decimal] NOT NULL,
  [Status] [smallint] NULL,
  [DateCreated] [datetime] NULL,
  [UserCreated] [uniqueidentifier] NULL,
  [DateModified] [datetime] NULL,
  [UserModified] [uniqueidentifier] NULL,
  PRIMARY KEY CLUSTERED ([WorkOrderID])
)
GO
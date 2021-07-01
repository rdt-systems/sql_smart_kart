CREATE TABLE [dbo].[JobOrder] (
  [JobOrderID] [int] IDENTITY,
  [TransactionEntryID] [uniqueidentifier] NULL,
  [Description] [nvarchar](300) NULL,
  [JobOrderStatus] [int] NULL,
  [Status] [smallint] NULL,
  [DateCreated] [datetime] NULL,
  [UserCreated] [uniqueidentifier] NULL,
  [DateModified] [datetime] NULL,
  [UserModified] [uniqueidentifier] NULL,
  CONSTRAINT [PK_JobOrder] PRIMARY KEY CLUSTERED ([JobOrderID])
)
GO

CREATE INDEX [IX_JobOrder]
  ON [dbo].[JobOrder] ([TransactionEntryID])
GO
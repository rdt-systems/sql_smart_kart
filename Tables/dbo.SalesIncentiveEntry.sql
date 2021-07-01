CREATE TABLE [dbo].[SalesIncentiveEntry] (
  [SalesIncentiveEntryID] [uniqueidentifier] NOT NULL,
  [TransactionEntryID] [uniqueidentifier] NULL,
  [IncentivePercent] [decimal] NULL,
  [IncentiveAmount] [money] NULL,
  [SalesValue] [decimal] NULL,
  [Posted] [bit] NULL,
  [Status] [int] NULL,
  [DateCreated] [datetime] NULL,
  [DateModified] [datetime] NULL,
  [UserCreated] [uniqueidentifier] NULL,
  [UserModified] [uniqueidentifier] NULL,
  CONSTRAINT [PK_SalesIncentiveEntry] PRIMARY KEY CLUSTERED ([SalesIncentiveEntryID])
)
GO
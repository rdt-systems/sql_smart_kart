CREATE TABLE [dbo].[Actions] (
  [ActionID] [uniqueidentifier] NOT NULL,
  [BatchID] [uniqueidentifier] NULL,
  [ActionType] [int] NULL,
  [ActionDate] [datetime] NULL,
  [UserID] [uniqueidentifier] NULL,
  [TransactionID] [uniqueidentifier] NULL,
  [RegisterID] [uniqueidentifier] NULL,
  [Status] [smallint] NULL,
  [DateCreated] [datetime] NULL,
  [UserCreated] [uniqueidentifier] NULL,
  [DateModified] [datetime] NULL,
  [UserModified] [uniqueidentifier] NULL,
  [ActionSum] [money] NULL,
  [Description] [nvarchar](50) NULL,
  [Info] [nvarchar](300) NULL,
  CONSTRAINT [PK_Actions] PRIMARY KEY CLUSTERED ([ActionID]) WITH (STATISTICS_NORECOMPUTE = ON)
)
GO

CREATE INDEX [IX_Actions_1]
  ON [dbo].[Actions] ([BatchID], [ActionType], [ActionDate], [TransactionID])
  WITH (STATISTICS_NORECOMPUTE = ON)
GO

CREATE INDEX [IX_Actions_2]
  ON [dbo].[Actions] ([ActionType])
  INCLUDE ([ActionID], [ActionDate], [UserID], [TransactionID])
  WITH (STATISTICS_NORECOMPUTE = ON)
GO

CREATE INDEX [IX_RecentActivity_Actions]
  ON [dbo].[Actions] ([ActionType])
  INCLUDE ([ActionDate], [UserID], [TransactionID], [RegisterID], [ActionSum], [Info])
  WITH (STATISTICS_NORECOMPUTE = ON)
GO
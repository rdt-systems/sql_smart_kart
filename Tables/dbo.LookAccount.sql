CREATE TABLE [dbo].[LookAccount] (
  [LookAccountID] [uniqueidentifier] NOT NULL,
  [CustomerID] [uniqueidentifier] NULL,
  [DaysOver] [smallint] NULL,
  [Ammount] [money] NULL,
  [Status] [smallint] NULL,
  [DateModified] [datetime] NULL,
  [UserModified] [uniqueidentifier] NULL,
  PRIMARY KEY CLUSTERED ([LookAccountID]) WITH (STATISTICS_NORECOMPUTE = ON)
)
GO
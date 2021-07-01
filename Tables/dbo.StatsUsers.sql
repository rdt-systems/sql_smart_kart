CREATE TABLE [dbo].[StatsUsers] (
  [StatId] [int] NULL,
  [UserId] [uniqueidentifier] NULL,
  [StatDateType] [int] NULL,
  [StatDateCount] [int] NULL,
  [DateCreated] [datetime] NULL,
  [UserCreated] [uniqueidentifier] NULL,
  [DateModified] [datetime] NULL,
  [UserModified] [uniqueidentifier] NULL
)
GO
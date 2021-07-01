CREATE TABLE [dbo].[StatsMain] (
  [StatId] [int] NULL,
  [StatDescription] [varchar](max) NULL,
  [StatSqlBegin] [varchar](max) NULL,
  [StatSql] [varchar](max) NULL,
  [StatSqlEnd] [varchar](max) NULL,
  [status] [int] NULL,
  [FormatType] [int] NULL,
  [Icon] [int] NULL,
  [Grid] [int] NULL,
  [DateCreated] [datetime] NULL,
  [UserCreated] [uniqueidentifier] NULL,
  [DateModified] [datetime] NULL,
  [UserModified] [uniqueidentifier] NULL
)
GO
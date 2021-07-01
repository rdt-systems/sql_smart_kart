CREATE TABLE [dbo].[StatsResults] (
  [StatId] [int] NULL,
  [StatsResult] [varchar](50) NULL,
  [status] [int] NULL,
  [DateCreated] [datetime] NULL,
  [UserCreated] [uniqueidentifier] NULL,
  [DateModified] [datetime] NULL,
  [UserModified] [uniqueidentifier] NULL,
  [UserId] [uniqueidentifier] NULL,
  [StoreID] [uniqueidentifier] NULL
)
GO

CREATE INDEX [IX_StatsResults]
  ON [dbo].[StatsResults] ([StatId], [StoreID], [UserId])
  WITH (STATISTICS_NORECOMPUTE = ON)
GO
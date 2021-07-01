CREATE TABLE [dbo].[RecentActivity] (
  [RecentActivityId] [int] IDENTITY,
  [ActivityType] [int] NULL,
  [TableName] [nvarchar](50) NULL,
  [Status] [int] NULL,
  [TableID] [nvarchar](50) NULL,
  [DateModified] [datetime] NULL,
  [IsGuid] [bit] NULL,
  [FieldName] [nvarchar](50) NULL,
  [UserId] [uniqueidentifier] NULL,
  [AdditionalInfo] [nvarchar](500) NULL
)
GO

CREATE INDEX [nci_wi_RecentActivity_1FC712873281ADD464302BACF3409B1E]
  ON [dbo].[RecentActivity] ([FieldName], [TableName], [ActivityType], [DateModified])
  INCLUDE ([AdditionalInfo], [RecentActivityId], [TableID], [UserId])
  WITH (STATISTICS_NORECOMPUTE = ON)
GO
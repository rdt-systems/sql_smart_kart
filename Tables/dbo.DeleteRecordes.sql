CREATE TABLE [dbo].[DeleteRecordes] (
  [TableName] [nvarchar](50) NULL,
  [Status] [int] NULL,
  [TableID] [nvarchar](50) NULL,
  [DateModified] [datetime] NULL,
  [IsGuid] [bit] NULL,
  [FieldName] [nvarchar](50) NULL
)
GO

CREATE INDEX [IX_DeleteRecordesDate]
  ON [dbo].[DeleteRecordes] ([DateModified])
  WITH (STATISTICS_NORECOMPUTE = ON)
GO
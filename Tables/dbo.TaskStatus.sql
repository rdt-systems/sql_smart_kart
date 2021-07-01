CREATE TABLE [dbo].[TaskStatus] (
  [TaskID] [uniqueidentifier] NOT NULL,
  [TaskDate] [datetime] NULL,
  [IsEnd] [bit] NULL,
  [Error] [nvarchar](1000) NULL,
  PRIMARY KEY CLUSTERED ([TaskID])
)
GO
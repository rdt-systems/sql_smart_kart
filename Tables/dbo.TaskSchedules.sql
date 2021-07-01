CREATE TABLE [dbo].[TaskSchedules] (
  [ID] [int] IDENTITY,
  [TaskName] [nvarchar](50) NULL,
  [Schedule] [nvarchar](50) NULL,
  [PathToExe] [nvarchar](250) NULL,
  [arguments] [nvarchar](50) NULL,
  [EmailOnFail] [bit] NULL,
  [LastRunDate] [datetime] NULL,
  [LastRunStatus] [int] NULL,
  [Enabled] [bit] NULL,
  [ExitCode] [nvarchar](20) NULL,
  [ProcessName] [nvarchar](50) NULL,
  [ProcessID] [int] NULL,
  CONSTRAINT [PK_TaskSchedules] PRIMARY KEY CLUSTERED ([ID])
)
GO
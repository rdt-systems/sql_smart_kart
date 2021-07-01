CREATE TABLE [dbo].[CustomerTasks] (
  [TaskID] [uniqueidentifier] NOT NULL,
  [CustomerID] [uniqueidentifier] NULL,
  [Description] [nvarchar](4000) NULL,
  [TaskStatus] [smallint] NULL,
  [TaskType] [smallint] NULL,
  [TaskDate] [datetime] NULL,
  [ScheduleDate] [datetime] NULL,
  [ScheduleHour] [nvarchar](50) NULL,
  [Note] [nvarchar](4000) NULL,
  [Priority] [smallint] NULL,
  [Status] [smallint] NULL,
  [DateCreated] [datetime] NULL,
  [UserCreated] [uniqueidentifier] NULL,
  [DateModified] [datetime] NULL,
  [UserModified] [uniqueidentifier] NULL,
  CONSTRAINT [PK_CustomerTasks] PRIMARY KEY CLUSTERED ([TaskID])
)
GO

CREATE INDEX [IX_CustomerTasks]
  ON [dbo].[CustomerTasks] ([CustomerID], [Status])
GO
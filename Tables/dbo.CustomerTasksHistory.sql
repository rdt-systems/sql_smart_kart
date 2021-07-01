CREATE TABLE [dbo].[CustomerTasksHistory] (
  [TaskID] [uniqueidentifier] NOT NULL,
  [TaskStatus] [smallint] NULL,
  [ScheduleHour] [nvarchar](50) NULL,
  [ScheduleDate] [datetime] NULL,
  [Note] [nvarchar](4000) NULL,
  [Priority] [smallint] NULL,
  [Status] [smallint] NULL,
  [DateCreated] [datetime] NULL,
  [UserCreated] [uniqueidentifier] NULL,
  [DateModified] [datetime] NULL,
  [UserModified] [uniqueidentifier] NULL,
  PRIMARY KEY CLUSTERED ([TaskID]) WITH (STATISTICS_NORECOMPUTE = ON)
)
GO
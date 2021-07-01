CREATE TABLE [dbo].[WorkerSchedule] (
  [WorkerScheduleID] [uniqueidentifier] NOT NULL,
  [UserID] [uniqueidentifier] NULL,
  [DayOfWeek] [int] NULL,
  [DateOfWeek] [datetime] NULL,
  [TimeIn] [timestamp] NULL,
  [TimeOut] [datetime] NULL,
  [TimeIn2] [datetime] NULL,
  [TimeOut2] [datetime] NULL,
  [Status] [int] NULL,
  [DateCreated] [datetime] NULL,
  [UserCreated] [uniqueidentifier] NULL,
  [DateModified] [datetime] NULL,
  [UserModified] [uniqueidentifier] NULL,
  PRIMARY KEY CLUSTERED ([WorkerScheduleID]) WITH (STATISTICS_NORECOMPUTE = ON)
)
GO
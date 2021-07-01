SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE VIEW [dbo].[WorkerScheduleView]
AS
SELECT     dbo.WorkerSchedule.WorkerScheduleID, dbo.Users.UserId, dbo.Users.UserName, dbo.Users.UserFName, dbo.Users.UserLName, dbo.WorkerSchedule.DayOfWeek, 
                      dbo.WorkerSchedule.DateOfWeek, dbo.WorkerSchedule.TimeIn, dbo.WorkerSchedule.TimeOut, dbo.WorkerSchedule.TimeIn2, dbo.WorkerSchedule.TimeOut2, 
                      dbo.WorkerSchedule.Status
FROM         dbo.WorkerSchedule INNER JOIN
                      dbo.Users ON dbo.WorkerSchedule.UserID = dbo.Users.UserId
WHERE     (dbo.Users.Status > - 1)
GO
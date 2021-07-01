SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO



CREATE VIEW [dbo].[CustomerTasksView]
AS
SELECT        CustomerTasks.TaskID, CustomerTasks.CustomerID, CustomerTasks.TaskType, CustomerTasks.ScheduleDate, CustomerTasks.TaskDate, CustomerTasks.Note, CustomerTasks.Priority, CustomerTasks.Status, 
                         CASE WHEN CustomerTasks.ScheduleHour IS NULL AND CustomerTasks.ScheduleDate IS NOT NULL THEN (CONVERT(varchar(8), CustomerTasks.ScheduleDate, 108)) 
                         WHEN CustomerTasks.ScheduleHour IS NULL AND CustomerTasks.ScheduleDate IS NULL THEN (CONVERT(varchar(8), CustomerTasks.TaskDate, 108)) ELSE CustomerTasks.ScheduleHour END AS ScheduleHour,
                          (CASE WHEN taskstatus = 1 THEN 'Open' WHEN taskstatus = 2 THEN 'Done' WHEN taskstatus = 3 THEN 'On Hold' WHEN taskstatus = 4 THEN 'Postponed' END) AS TaskStatusDesc, CustomerTasks.TaskStatus, 
                         CustomerTasks.DateCreated, CustomerTasks.UserCreated, CustomerTasks.DateModified, CustomerTasks.UserModified, ISNULL(CustomerView.Name, '') AS CustomerName, 
                         TaskType.SystemValueName AS TaskName, ISNULL(CustomerView.Address, '') AS Address, ISNULL(CustomerView.CityStateAndZip, '') AS CityStateAndZip, CustomerView.CustomerNo, 
                         CustomerTasks.Description, Users.UserName AS CreateBy, BalanceDoe
FROM            CustomerTasks INNER JOIN
                         CustomerView ON CustomerTasks.CustomerID = CustomerView.CustomerID INNER JOIN
                         Users ON CustomerTasks.UserCreated = Users.UserId LEFT OUTER JOIN
                             (SELECT        SystemValueNo, SystemValueName
                               FROM            SystemValues
                               WHERE        (SystemTableNo = 55)) AS TaskType ON CustomerTasks.TaskType = TaskType.SystemValueNo
GO
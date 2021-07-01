SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE procedure [dbo].[SP_GetAllReports]

as 

SELECT reportsTable.*, TaskSchedules.Schedule
FROM reportsTable  LEFT OUTER JOIN dbo.TaskSchedules ON TaskSchedules.PathToExe=reportsTable.reportDll
WHERE reportsTable.status=1
AND reportsTable.reportDll IS NOT NULL
ORDER  BY dbo.ReportsTable.ReportSection,  dbo.ReportsTable.SortOrder
GO
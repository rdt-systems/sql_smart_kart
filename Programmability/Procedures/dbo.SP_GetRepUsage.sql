SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO

CREATE procedure [dbo].[SP_GetRepUsage]
(@UserId uniqueidentifier)
as 


SELECT TOP 10  ReportsUsed.RepNama AS ReportName,reportsTable.ReportDescription,reportsTable.Icon, COUNT(*) AS count	 
FROM ReportsUsed LEFT	JOIN reportsTable ON ReportsUsed.RepNama=reportsTable.ReportName
WHERE UserId =@UserId
GROUP BY RepNama,reportsTable.ReportDescription,reportsTable.Icon
ORDER BY COUNT desc
GO
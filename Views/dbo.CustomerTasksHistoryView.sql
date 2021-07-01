SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE    VIEW [dbo].[CustomerTasksHistoryView]
AS
SELECT     dbo.CustomerTasksHistory.*,(case when taskstatus = 1 then 'Planed'
  when taskstatus=2 then 'Done'
  when taskstatus=3 then 'On Hold'
  when taskstatus=4 then 'Postponed' end)as TaskStatusDesc
FROM         dbo.CustomerTasksHistory
WHERE     (Status > - 1)
GO
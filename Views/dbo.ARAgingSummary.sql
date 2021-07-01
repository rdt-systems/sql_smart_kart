SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE         View [dbo].[ARAgingSummary] 
AS

SELECT OpenBalance,
     (case  when DueDate > (select Convert(varchar,dbo.GetLocalDATE(),111)) then 'Current' 
            when DueDate <= (select Convert(varchar,dbo.GetLocalDATE(),111)) and DueDate > DATEADD(day, - 30, (select Convert(varchar,dbo.GetLocalDATE(),111))) then '0-30'
            when DueDate <= DATEADD(day, - 30, (select Convert(varchar,dbo.GetLocalDATE(),111))) AND DueDate > DATEADD(day, - 60, (select Convert(varchar,dbo.GetLocalDATE(),111))) then '30'
            when DueDate <= DATEADD(day, - 60, (select Convert(varchar,dbo.GetLocalDATE(),111))) AND DueDate > DATEADD(day, - 90, (select Convert(varchar,dbo.GetLocalDATE(),111))) then '60'
            when DueDate <= DATEADD(day, - 90, (select Convert(varchar,dbo.GetLocalDATE(),111))) AND DueDate > DATEADD(day, - 120, (select Convert(varchar,dbo.GetLocalDATE(),111))) then '90'
            when DueDate <= DATEADD(day, - 120, (select Convert(varchar,dbo.GetLocalDATE(),111))) then '120' 
end) as Aging 
FROM InvoicesView
Where Status>0
GO
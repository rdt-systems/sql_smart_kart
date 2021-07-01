SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE procedure [dbo].[SP_OneTasksHistory]
(@TaskID uniqueidentifier, @refreshTime  datetime output)
as

select * from dbo.CustomerTasksHistoryView
where TaskID=@TaskID
set @refreshTime = dbo.GetLocalDATE()
GO
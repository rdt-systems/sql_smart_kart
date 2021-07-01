SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SP_CustomerTasksHistoryInsert]
(
@TaskID	uniqueidentifier,	
@TaskStatus	smallint,	
@ScheduleDate	datetime,	
@ScheduleHour   nvarchar(50),
@Note	nvarchar (4000),	
@Priority	smallint,	
@Status	smallint,	
@ModifierID	uniqueidentifier
)

AS INSERT INTO dbo.CustomerTasksHistory
(TaskID,TaskStatus,ScheduleDate,ScheduleHour, Note,Priority,Status,DateCreated,UserCreated,DateModified,UserModified	)
	
VALUES     (
@TaskID,@TaskStatus,@ScheduleDate, @ScheduleHour,@Note,@Priority,
		1, dbo.GetLocalDATE(), @ModifierID, dbo.GetLocalDATE(), @ModifierID)
GO
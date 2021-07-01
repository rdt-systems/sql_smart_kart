SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SP_CustomerTasksInsert]
(
@TaskID	uniqueidentifier,	
@CustomerID	uniqueidentifier,
@Description nvarchar(200),
@TaskStatus	smallint,	
@TaskType	smallint,		
@TaskDate	datetime,		
@ScheduleDate	datetime,	
@ScheduleHour nvarchar(50),
@Note	nvarchar (4000),	
@Priority	smallint,	
@Status	smallint,	
@ModifierID	uniqueidentifier
)

AS
Declare @Date DateTime
Set @Date = ISNULL(@ScheduleDate,@TaskDate)

INSERT INTO dbo.CustomerTasks
(TaskID,CustomerID,Description ,TaskStatus,TaskType,TaskDate,ScheduleDate,ScheduleHour,Note,Priority,Status,DateCreated	,UserCreated,DateModified,UserModified	)
	
VALUES     (
@TaskID	,@CustomerID,@Description,@TaskStatus,@TaskType,@TaskDate,@Date,@ScheduleHour,@Note,@Priority,
		1, dbo.GetLocalDATE(), @ModifierID, dbo.GetLocalDATE(), @ModifierID)
GO
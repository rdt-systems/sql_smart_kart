SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SP_CustomerTasksHistoryUpdate]
(

@TaskID	uniqueidentifier,	
@TaskStatus	smallint,			
@ScheduleDate	datetime,	
@ScheduleHour   nvarchar(50),
@Note	nvarchar (4000),	
@Priority	smallint,	
@Status	smallint,	
@DateModified datetime,
@ModifierID	uniqueidentifier	
)

AS
Declare @UpdateTime datetime
set  @UpdateTime =dbo.GetLocalDATE()

UPDATE dbo.CustomerTasksHistory
                    
SET    

TaskID	=@TaskID,	
TaskStatus=@TaskStatus,		
ScheduleDate=@ScheduleDate	,	
ScheduleHour=@ScheduleHour,
Note=@Note,	
Priority=@Priority,
Status=@Status,	
UserModified=@ModifierID,
DateModified=@UpdateTime


WHERE (TaskID =@TaskID)AND 
(DateModified = @DateModified OR DateModified IS NULL) 



select @UpdateTime as DateModified
GO
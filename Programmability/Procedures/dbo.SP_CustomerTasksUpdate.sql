SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SP_CustomerTasksUpdate]
           (@TaskID	uniqueidentifier,	
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
			@DateModified datetime,
			@ModifierID	uniqueidentifier	
)
AS
Declare @UpdateTime datetime
set  @UpdateTime =dbo.GetLocalDATE()

Declare @Date DateTime
Set @Date = ISNULL(@ScheduleDate,@TaskDate)

UPDATE [dbo].[CustomerTasks]
   SET [CustomerID] = @CustomerID
      ,[Description] = @Description
      ,[TaskStatus] = @TaskStatus
      ,[TaskType] = @TaskType
      ,[TaskDate] = @TaskDate
      ,[ScheduleDate] = @Date
      ,[ScheduleHour] = @ScheduleHour
      ,[Note] = @Note
      ,[Priority] = @Priority
      ,[Status] = @Status
      ,[DateModified] = @UpdateTime
      ,[UserModified] = @ModifierID
 WHERE [TaskID] = @TaskID
GO
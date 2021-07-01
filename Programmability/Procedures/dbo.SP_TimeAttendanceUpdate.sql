SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SP_TimeAttendanceUpdate]

(      
		   @PunchID int,
		   @UserID uniqueidentifier,
           @InTime datetime,
		   @OutTime datetime,
           @Status int,
           @InOutID int,
           @StoreID uniqueidentifier,
           @Ragulare decimal(18, 2),
           @Holiday decimal(18, 2),
           @OverTime decimal(18, 2),
           @Sick decimal(18, 2),
		   @DateModified datetime,
           @ModifierID uniqueidentifier)
AS 

Update Punches set Ragulare = @Ragulare, Holiday = @Holiday, OverTime = @OverTime, Sick = @Sick, PunchTime = @InTime,
 UserModified = @ModifierID, Status = @Status, DateModified = @DateModified
Where PunchID = @PunchID 


UPDATE Punches Set PunchTime = @OutTime , UserModified = @ModifierID, Status = @Status, DateModified = @DateModified
Where InOutID = @InOutID AND PunchType = 0

if (@@RowCount = 0 and @InOutID is not null) begin
Insert Into Punches(InOutID, PunchTime, PunchType, Status, UserID, DateCreated)
Values (@InOutId, @OutTime, 0,1,@UserID,dbo.GetLocalDATE())
end

select * from Punches

Declare @UpdateTime datetime
set  @UpdateTime =dbo.GetLocalDATE()
GO
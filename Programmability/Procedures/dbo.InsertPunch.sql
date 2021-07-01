SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO



CREATE PROCEDURE [dbo].[InsertPunch] 
(
@PunchTime dateTime ,
@PunchType bit,--1 = IN, 0 = Out
@Password nvarchar(50) ,
@Result nvarchar(20) out,
@RegisterID nvarchar(50) = null,
@StoreID uniqueidentifier = Null,
@userID uniqueidentifier = null
)

AS
Declare @vUserID uniqueidentifier
Declare @ID  int

print '1'
if @UserID IS NULL
BEGIN
	Set @vUserID = (Select UserId from users where Password = @Password and status > -1)
	if @vUserID is null 
	begin
		Set @Result = 'Password invalid'
		Return
	end
END
ELSE BEGIN
  Set @vUserID =@userID 
END

print '2'
Declare @LastPunch bit

--Check if the last punch was not the same as that type.
Set @LastPunch = (SELECT Top(1) PunchType FROM Punches WHERE UserID = @vUserID And Status > -1 Order By PunchTime desc) 

print '3'
If @LastPunch Is Null
BEGIN
print 'A3'
	If @PunchType = 1 Begin
	    SET @ID=(SELECT IsNull(MAX(InOutID),0) FROM Punches)+1
		Insert Into Punches(InOutID,PunchTime,PunchType,UserID,Status,RegisterID,StoreID) Values (@ID,@PunchTime, @PunchType, @vUserID, 1, @RegisterID,@StoreID )
		Set @Result = 'Good'
		Return 
	End

    IF @PunchType = 0 BEGIN
	   Set @Result = 'No Punch in Found!'
	   Return 
    End
    print '4'
END

IF @LastPunch = 1
Begin
	If @PunchType = 0 Begin
		Set @ID = (SELECT Top(1) InOutID FROM Punches WHERE UserID = @vUserID And Status > -1 Order By PunchTime desc) 
		Insert Into Punches(InOutID,PunchTime,PunchType,UserID,Status,RegisterID) Values (@ID,@PunchTime, @PunchType, @vUserID, 1,@RegisterID)
		Set @Result = 'Clock Out'
		Return 
	End

	If @PunchType = 1 Begin
		Set @Result = 'No punch out found!'
		Return 
	End
End

If @LastPunch = 0
Begin
	If @PunchType = 1 Begin
		SET @ID=(SELECT IsNull(MAX(InOutID),0) FROM Punches)+1
		Insert Into Punches(InOutID,PunchTime,PunchType,UserID,Status,RegisterID,StoreID) Values (@ID,@PunchTime, @PunchType, @vUserID, 1, @RegisterID,@StoreID )
		Set @Result = 'Clock In'
		Return 
	End

	If @PunchType = 0 Begin
		Set @Result = 'No punch in found!'
		Return 
	End
End
GO
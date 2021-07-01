SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


--ALTER 
CREATE PROCEDURE [dbo].[SP_LoyaltySetupUpdate]
(@LoyaltySetupID uniqueidentifier,
@DayOfWeek int,
@FromTime datetime,
@ToTime datetime,
@Point decimal (18,2) ,
@Amount money,
@MemberType smallint,
@Status int,
@DateModified DateTime,
@ModifierID uniqueidentifier)
AS 


UPDATE  dbo.LoyaltySetup
SET  
	DayOfWeek = @DayOfWeek, 
	FromTime = @FromTime, 
	ToTime = @ToTime, 
	Point=@Point,
	Amount= @Amount,
	MemberType=@MemberType,
	Status=@Status,
	DateModified=dbo.GetLocalDATE(),
	UserModified=@ModifierID

WHERE (LoyaltySetupID=@LoyaltySetupID)
GO
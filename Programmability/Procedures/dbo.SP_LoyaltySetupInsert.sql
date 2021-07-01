SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


--ALTER 
CREATE PROCEDURE [dbo].[SP_LoyaltySetupInsert]
(@LoyaltySetupID uniqueidentifier,
@DayOfWeek int,
@FromTime datetime,
@ToTime datetime,
@Point decimal (18,2) ,
@Amount money,
@MemberType smallint,
@Status int,
@ModifierID uniqueidentifier)
AS 


Insert into  dbo.LoyaltySetup
(  
	LoyaltySetupID,
	DayOfWeek, 
	FromTime, 
	ToTime, 
	Point,
	Amount,
	MemberType,
	Status,
	DateModified,
	UserModified
)
values
(  
	@LoyaltySetupID,
	@DayOfWeek, 
	@FromTime, 
	@ToTime, 
	@Point,
	@Amount,
	@MemberType,
	@Status,
	dbo.GetLocalDATE(),
	@ModifierID
)
GO
SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO



CREATE VIEW [dbo].[LoyaltySetupView]
AS
SELECT        Amount, DateModified, DayOfWeek, FromTime, ToTime, LoyaltySetupID, Point, Status, UserModified, MemberType, dbo.FormatDateTime(ToTime, 'HH:MM 24') 
                         AS NToTime, dbo.FormatDateTime(FromTime, 'HH:MM 24') AS NFromTime
FROM            dbo.LoyaltySetup
GO
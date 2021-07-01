SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


create VIEW [dbo].[ClubView]
AS
SELECT     ClubID, ClubName, Status, DateCreated, UserCreated, DateModified, UserModified
FROM         dbo.Club
GO
SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SP_SeasonInsert]

(@SeasonId uniqueidentifier,
@Name nvarchar(50),
@Description nvarchar(4000),
@StartDate datetime,
@EndDate datetime,
@Status smallint,
@ModifierID uniqueidentifier)

AS INSERT INTO dbo.Season
                      (SeasonId,   Name,    Description,     StartDate,     EndDate,    Status, DateCreated, UserCreated, DateModified, UserModified)
VALUES     (@SeasonId, dbo.CheckString(@Name), dbo.CheckString(@Description), @StartDate, @EndDate,    1,         dbo.GetLocalDATE(), @ModifierID, dbo.GetLocalDATE(), @ModifierID)
GO
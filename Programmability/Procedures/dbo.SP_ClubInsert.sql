SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SP_ClubInsert]
(@ClubID nvarchar(50),
@ClubName uniqueidentifier,
@StoreID nvarchar(50),
@Status smallint,
@ModifierID uniqueidentifier)
AS INSERT INTO dbo.Club
                      (ClubID, ClubName, StoreID,Status, DateModified)
VALUES     (@ClubID, dbo.CheckString(@ClubName), @StoreID,1,dbo.GetLocalDATE())
GO
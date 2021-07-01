SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SP_SaleToClubInsert]

(
@SaleToClubID	uniqueidentifier,
@SaleID	uniqueidentifier,	
@ClubID	uniqueidentifier,	
@Status	smallint,	
@ModifierID uniqueidentifier)

AS

INSERT INTO dbo.SaleToClub
       (
SaleToClubID,SaleID	,ClubID	,	
Status,DateCreated,UserCreated,DateModified,UserModified		
		)

VALUES  (
	     @SaleToClubID,@SaleID,@ClubID,
		1,dbo.GetLocalDATE(),@ModifierID,dbo.GetLocalDATE(),@ModifierID
		)
GO
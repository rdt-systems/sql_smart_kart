SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SP_SaleToClubDelete]
(@SaleToClubID	uniqueidentifier,
@ModifierID uniqueidentifier)
as
update SaleToClub
set Status=-1, datemodified=dbo.GetLocalDATE(),UserModified=@ModifierID
where SaleToClubID=@SaleToClubID
and status>0
GO
SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


-- =============================================
-- Author:		<Nathan Ehrenthal>
-- ALTER date: <3/12/2012>
-- Description:	Update >
-- =============================================
CREATE PROCEDURE [dbo].[SP_DiscountFromLinkInsert]
	(@ID uniqueidentifier ,
	 @LinkID uniqueidentifier,
	 @Status int=1,
	 @DiscountID uniqueidentifier,
	 @ModifierID	uniqueidentifier)
AS
BEGIN
  INSERT INTO DiscountFromLink
                      (ID, LinkID, Status, DiscountID, UserCreated, DateCreated, UserModified, DateModified)
VALUES     (@ID,@LinkID,@Status,@DiscountID,@ModifierID, dbo.GetLocalDATE(),@ModifierID, dbo.GetLocalDATE())
	
END
GO
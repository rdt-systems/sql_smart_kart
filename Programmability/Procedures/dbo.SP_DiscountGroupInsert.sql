SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


-- =============================================
-- Author:		<Nathan Ehrenthal>
-- ALTER date: <3/19/2012>
-- Description:	Update >
-- =============================================
CREATE PROCEDURE [dbo].[SP_DiscountGroupInsert]
	(@DiscountGroupID uniqueidentifier,
	@GroupNo varchar(50) ,
	 @Name nvarchar(50) ,
	 @Status int=1,
	 @ModifierID uniqueidentifier)
AS
BEGIN
INSERT INTO DiscountGroup
                      (DiscountGroupID, GroupNo, DateCreated, UserCreated, DateModified, UserModified, Status, Name)
VALUES     (@DiscountGroupID,@GroupNo, dbo.GetLocalDATE(),@ModifierID, dbo.GetLocalDATE(),@ModifierID,@Status,@Name)
	
END
GO
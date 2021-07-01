SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


-- =============================================
-- Author:		<Nathan Ehrenthal>
-- ALTER date: <3/19/2012>
-- Description:	Update >
-- =============================================
CREATE PROCEDURE [dbo].[SP_DiscountGroupUpdate]
	(@DiscountGroupID uniqueidentifier,
	 @DiscountID uniqueidentifier,
	 @GroupNo varchar(50) ,
	 @Name nvarchar(50) ,
	 @Status int=1,
	 @ModifierID uniqueidentifier)
AS
BEGIN
   UPDATE    DiscountGroup
SET              DiscountID =@DiscountID, GroupNo =@GroupNo, UserModified =@ModifierID, DateModified =dbo.GetLocalDATE(), Status =@Status, Name = @Name
	WHERE DiscountGroupID =@DiscountGroupID  
	
END
GO
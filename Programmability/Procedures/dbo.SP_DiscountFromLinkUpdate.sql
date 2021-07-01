SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


-- =============================================
-- Author:		<Nathan Ehrenthal>
-- ALTER date: <3/12/2012>
-- Description:	Update >
-- =============================================
CREATE PROCEDURE [dbo].[SP_DiscountFromLinkUpdate]
	(@ID uniqueidentifier ,
	 @LinkID uniqueidentifier,
	 @Status int=1,
	 @DiscountID uniqueidentifier,
	 @ModifierID	uniqueidentifier)
AS
BEGIN
    UPDATE DiscountFromLink SET
		LinkID=@LinkID,
		Status=@Status ,
		DiscountID=@DiscountID ,
		UserModified=@ModifierID ,
		DateModified=dbo.GetLocalDATE()
	WHERE ID =@ID  
	
END
GO
SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SP_ItemGroupDelete]
(@ItemGroupID uniqueidentifier,
@ModifierID uniqueidentifier)

AS
Update  dbo.ItemGroup
                 
            	
SET  Status =-1,   DateModified= dbo.GetLocalDATE(),   UserModified= @ModifierID
	
WHERE  ItemGroupID= @ItemGroupID
GO
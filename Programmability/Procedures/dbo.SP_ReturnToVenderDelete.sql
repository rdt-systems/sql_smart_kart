SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SP_ReturnToVenderDelete]
(@ReturnToVenderID char(50),
@ModifierID uniqueidentifier)
As
 UPDATE dbo. ReturnToVender
 
SET   Status = -1, DateModified = dbo.GetLocalDATE(), UserModified = @ModifierID

WHERE ReturnToVenderID =  @ReturnToVenderID
GO
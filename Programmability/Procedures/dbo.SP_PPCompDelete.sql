SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SP_PPCompDelete]
(@PPCompID uniqueidentifier,
@ModifierID uniqueidentifier)
AS UPDATE    dbo.PPComp
SET              Status=-1, 
DateModified = dbo.GetLocalDATE()
WHERE  PPCompID = @PPCompID
GO
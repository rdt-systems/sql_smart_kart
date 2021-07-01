SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SP_BatchDelete]

(@BatchID uniqueidentifier,
@ModifierID uniqueidentifier)

AS

Update dbo.batch
SET
       	
	Status=-1,
	DateModified=dbo.GetLocalDATE(),
	UserModified=@ModifierID

WHERE BatchID=@BatchID
GO
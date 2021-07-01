SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SP_MixAndMatchDelete]
(@MixAndMatchID uniqueidentifier,
@ModifierID uniqueidentifier)

AS UPDATE dbo.MixAndMatch
SET
	 Status=-1,
	DateModified =dbo.GetLocalDATE()
WHERE    MixAndMatchID = @MixAndMatchID
GO
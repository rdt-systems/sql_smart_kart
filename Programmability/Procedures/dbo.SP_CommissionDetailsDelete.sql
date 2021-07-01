SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SP_CommissionDetailsDelete]
(@CommissionDetailsID uniqueidentifier,
@ModifierID uniqueidentifier)

AS UPDATE    dbo.CommissionDetails
SET	Status = -1,
	DateModified = dbo.GetLocalDATE(),
	userModified=@ModifierID
	
WHERE	CommissionDetailsID = @CommissionDetailsID
GO
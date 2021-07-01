SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SP_ExtraChargeDelete]
(@ExtraChargeID uniqueidentifier,
@ModifierID uniqueidentifier)
AS
UPDATE	dbo.ExtraCharge
SET	Status = -1 ,DateModified = dbo.GetLocalDATE()
WHERE	ExtraChargeID = @ExtraChargeID
GO
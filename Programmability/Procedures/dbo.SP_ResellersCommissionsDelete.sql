SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SP_ResellersCommissionsDelete]
(@CommissionID uniqueidentifier,
@ModifierID uniqueidentifier)

AS UPDATE    dbo.ResellersCommissions
SET	Status = -1,
	DateModified = dbo.GetLocalDATE(),
	userModified=@ModifierID
	
WHERE	CommissionID = @CommissionID

	DECLARE @CommissionDetailsID uniqueidentifier
	
	DECLARE DelDetails CURSOR FORWARD_ONLY STATIC OPTIMISTIC FOR
	SELECT CommissionDetailsID
	FROM dbo.CommissionDetails WHERE(CommissionID=@CommissionID) 
	
	OPEN DelDetails
	
	FETCH NEXT FROM DelDetails 
	INTO @CommissionDetailsID   -- holds the current transaction entry
	
	WHILE @@FETCH_STATUS = 0
		BEGIN
			exec SP_CommissionDetailsDelete @CommissionDetailsID,@ModifierID
		FETCH NEXT FROM DelDetails    --insert the next values to the instance
			INTO @CommissionDetailsID
		END
	
	CLOSE DelDetails
	DEALLOCATE DelDetails
GO
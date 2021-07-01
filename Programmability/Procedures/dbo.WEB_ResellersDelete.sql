SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[WEB_ResellersDelete]
(@ResellerID uniqueidentifier)

AS UPDATE    dbo.Resellers
SET	Status = -1,
	DateModified = dbo.GetLocalDATE()
	
WHERE	ResellerID = @ResellerID
GO
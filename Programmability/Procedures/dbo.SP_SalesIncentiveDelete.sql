SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SP_SalesIncentiveDelete]
	@SalesIncentiveID uniqueidentifier,
	@ModifierID uniqueidentifier
AS


	update dbo.SalesIncentive
	set Status = -1, DateModified = dbo.GetLocalDATE(),
		UserModified = @ModifierID
	where SalesIncentiveID = @SalesIncentiveID
GO
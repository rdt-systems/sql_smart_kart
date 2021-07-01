SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SP_SalesIncentiveEntryDelete]
	@SalesIncentiveEntryID uniqueidentifier,
	@ModifierID uniqueidentifier
AS


	update dbo.SalesIncentiveEntry
	set Status = -1, DateModified = dbo.GetLocalDATE(),
		UserModified = @ModifierID
	where SalesIncentiveEntryID = @SalesIncentiveEntryID
GO
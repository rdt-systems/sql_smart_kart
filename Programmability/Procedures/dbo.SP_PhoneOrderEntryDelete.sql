SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SP_PhoneOrderEntryDelete]
(
@PhoneOrderEntryID 	uniqueidentifier,
@ModifierID 	uniqueidentifier)

AS

UPDATE dbo.PhoneOrderEntry
SET
	Status=	 -1,
	DateModified=dbo.GetLocalDATE(),
	UserModified=@ModifierID
WHERE   (PhoneOrderEntryID = @PhoneOrderEntryID)
GO
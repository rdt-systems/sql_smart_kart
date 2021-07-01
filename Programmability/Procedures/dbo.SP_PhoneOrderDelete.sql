SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SP_PhoneOrderDelete]
(
@PhoneOrderID 	uniqueidentifier,
@ModifierID 	uniqueidentifier)

AS

UPDATE dbo.PhoneOrder
SET
	Status=	 -1,
	DateModified=dbo.GetLocalDATE(),
	UserModified=@ModifierID
WHERE   (PhoneOrderID = @PhoneOrderID)
GO
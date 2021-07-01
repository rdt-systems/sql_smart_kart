SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SP_PhoneDelete]
(@PhoneID uniqueidentifier,
@ModifierID uniqueidentifier)
AS UPDATE    dbo.Phone
SET              Status = -1, DateModified = dbo.GetLocalDATE()
WHERE PhoneID = @PhoneID
GO
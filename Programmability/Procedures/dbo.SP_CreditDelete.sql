SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SP_CreditDelete]
(@CreditID uniqueidentifier,
@ModifierID uniqueidentifier)
AS UPDATE dbo.Credit
SET Status = -1, DateModified = dbo.GetLocalDATE(), UserModified = @ModifierID
WHERE CreditID = @CreditID
GO
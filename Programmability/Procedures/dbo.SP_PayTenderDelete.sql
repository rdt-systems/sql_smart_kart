SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SP_PayTenderDelete]
(@PayTenderID uniqueidentifier,
@ModifierID uniqueidentifier)

As
UPDATE PayTender

SET Status = -1, DateModified = dbo.GetLocalDATE(), UserModified = @ModifierID


WHERE PayTenderID =@PayTenderID
GO
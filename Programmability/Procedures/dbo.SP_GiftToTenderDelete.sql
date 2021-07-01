SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SP_GiftToTenderDelete]
(@GiftToTenderID uniqueidentifier,
@ModifierID uniqueidentifier)
AS
Update GiftToTender
     SET       Status = -1 ,  DateModified = dbo.GetLocalDATE() , UserModified = @ModifierID
WHERE  GiftToTenderID = @GiftToTenderID
GO
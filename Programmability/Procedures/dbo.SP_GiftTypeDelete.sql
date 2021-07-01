SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SP_GiftTypeDelete]
(@GiftTypeId uniqueidentifier,
@ModifierID uniqueidentifier)
AS
--UPDATE  odb.giftType
--SET     Status = -1, 
--          DateModified =  dbo.GetLocalDATE(), UserModified = @ModifierID

--WHERE GiftTypeId = @GiftTypeId
GO
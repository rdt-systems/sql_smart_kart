SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SP_AttachmentsDelete](@AttachmentID uniqueidentifier,
@ModifierID uniqueidentifier)
AS UPDATE    dbo.Attachments
SET              Status = - 1, DateModified = dbo.GetLocalDATE(), UserModified = @ModifierID
WHERE     (AttachmentID = @AttachmentID)
GO
SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SP_AttachmentsInsert]
(@AttachmentID uniqueidentifier,
@ItemStoreID  uniqueidentifier,
@Description nvarchar(4000),
@FileName nvarchar(4000),
@Attachment image,
@Status smallint,
@ModifierID uniqueidentifier)
AS INSERT INTO dbo.Attachments
                      (AttachmentID, ItemStoreID, Description, FileName,Attachment, Status, DateCreated, UserCreated, DateModified, UserModified)
VALUES     (@AttachmentID, @ItemStoreID, dbo.CheckString(@Description),@FileName, @Attachment, 1, dbo.GetLocalDATE(), @ModifierID, dbo.GetLocalDATE(), @ModifierID)
GO
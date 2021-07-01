SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SP_AttachmentsUpdate](@AttachmentID uniqueidentifier,
@ItemStoreID uniqueidentifier,
@Description nvarchar(4000),
@FileName nvarchar(4000),
@Attachment image,
@Status smallint,
@DateModified datetime,
@ModifierID uniqueidentifier)
AS

Declare @UpdateTime datetime
set  @UpdateTime =dbo.GetLocalDATE()

 UPDATE    dbo.Attachments
SET              ItemStoreID = @ItemStoreID, [Description] = dbo.CheckString(@Description), FileName = @FileName, Attachment = @Attachment, Status = 

@Status, 
                      DateModified =@UpdateTime, UserModified = @ModifierID
WHERE     (AttachmentID = @AttachmentID) AND (DateModified = @DateModified OR
                      DateModified IS NULL)

select @UpdateTime as DateModified
GO
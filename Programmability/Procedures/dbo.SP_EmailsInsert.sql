SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SP_EmailsInsert]
(@EmailID uniqueidentifier,
@Subject nvarchar(50),
@Body ntext,
@From nvarchar(50),
@FromAddress nvarchar(50),
@To nvarchar(50),
@ToAddress nvarchar(50),
@DeliveryDate datetime,
@MailType int,
@MailStatus smallint,
@EmailUid nvarchar(2000),
@Attachment image,
@FileName Nvarchar(50),
@Status smallint,
@EmailText nvarchar(4000) = NULL,
@ModifierID uniqueidentifier)

AS INSERT INTO [dbo].[Emails]
           ([EmailID], [Subject], [Body], [From],FromAddress, [To],ToAddress,[DeliveryDate],[MailType],[MailStatus],[EmailUid], [EmailText],
			Attachment ,[FileName] , [Status], [DateCreated], [UserCreated], [DateModified], [UserModified])
     VALUES
           (@EmailID, @Subject, @Body, @From,@FromAddress, @To,@ToAddress,@DeliveryDate,@MailType,@MailStatus,@EmailUid, @EmailText,
            @Attachment ,@FileName ,1, dbo.GetLocalDATE(), @ModifierID, dbo.GetLocalDATE(), @ModifierID)
GO
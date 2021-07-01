SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SP_EmailTemplateInsert]
(@EmailTemplateID uniqueidentifier,
@EmailFrom nvarchar(50),
@Subject nvarchar(50),
@Body ntext,
@EmailContent image,
@Category int,
@FileName nvarchar(50),
@Status smallint,
@ModifierID uniqueidentifier)

AS INSERT INTO [dbo].EmailTemplate
           ([EmailTemplateID], EmailFrom, [Subject], [Body],EmailContent ,Category,[FileName], Status)
     VALUES
           (@EmailTemplateID,@EmailFrom, @Subject, @Body,@EmailContent ,@Category,@FileName, @Status)
GO
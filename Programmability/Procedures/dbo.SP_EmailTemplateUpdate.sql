SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SP_EmailTemplateUpdate]
(@EmailTemplateID uniqueidentifier,
@EmailFrom nvarchar(50),
@Subject nvarchar(50),
@Body ntext,
@EmailContent image,
@Category int,
@FileName nvarchar(50),
@Status smallint,
@DateModified datetime=NULL,
@ModifierID uniqueidentifier)

AS Update  [dbo].EmailTemplate
SET          
	EmailFrom=@EmailFrom,
	Subject=@Subject, 
	Body=@Body,
	EmailContent= @EmailContent,
	Category=@Category,
	[FileName]=@FileName, 
	Status=@Status
where
	EmailTemplateID=@EmailTemplateID
GO
SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


create PROCEDURE [dbo].[SP_EmailTemplateDelete]
(@EmailTemplateID uniqueidentifier,
@ModifierID uniqueidentifier)

AS Update  [dbo].EmailTemplate
SET  
	Status=-1
where        
	EmailTemplateID=@EmailTemplateID
GO
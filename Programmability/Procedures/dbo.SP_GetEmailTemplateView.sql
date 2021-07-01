SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


create PROCEDURE [dbo].[SP_GetEmailTemplateView]
AS

   SELECT     dbo.EmailTemplateView.*
   FROM         dbo.EmailTemplateView
   WHERE     (Status > -1)
GO
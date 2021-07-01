SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE VIEW [dbo].[EmailTemplateView]
AS
SELECT     EmailTemplateID, EmailFrom, Subject, Body, EmailContent, Category, FileName, Status
FROM         dbo.EmailTemplate
GO
SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE procedure [dbo].[SP_GetUnReadMails]

as

Select *
from dbo.Emails
where MailStatus=1 And 
	  Status>-1 And 
	  MailType=0
GO
SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO



CREATE VIEW [dbo].[EmailsView]
AS
SELECT     EmailID, Subject, Body, [From], [To], DeliveryDate, FromAddress, ToAddress, MailType, MailStatus, EmailUid, Attachment, FileName, EmailText, Status, 
                      DateCreated, UserCreated, DateModified, UserModified
FROM         dbo.Emails
GO
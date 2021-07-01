SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO

CREATE VIEW [dbo].[EmailsEntriesCorrect]
AS
Select 
EmailID, Subject, Body, [From], FromAddress, [To], ToAddress, DeliveryDate, MailType, MailStatus, 
EmailUid, Attachment, FileName, Status, DateCreated, UserCreated, UserModified, DateModified, 
ErrorMessage, TransactionID, EmailText, dbo.MatchTransWithEntry(E.TransactionID) AS Wrong,
CAST(convert(varchar(10), ((( CAST(DATEDIFF(SECOND,DateCreated,dbo.GetLocalDate()) as int) %86400)%3600)/60)) as Int) AS PendingMin from Emails E
Where E.Status = 1 AND E.TransactionID IS NOT NULL

GO
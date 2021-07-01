SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE VIEW [dbo].[AccountView]
AS
SELECT     AccountID, AccountName, AccountDescription, Status, DateModified
FROM         dbo.Accounts
GO
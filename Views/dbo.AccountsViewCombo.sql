SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE VIEW [dbo].[AccountsViewCombo]
AS
SELECT     AccountName, AccountID
FROM         dbo.Accounts
GO
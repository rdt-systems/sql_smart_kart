SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO



CREATE  VIEW [dbo].[CreditView]
AS
SELECT        CreditID, Name, Description, Days, InterestRate, CreditType, NetDue, DayInMonth, Status, DateCreated, UserCreated, DateModified, UserModified, InterestRate2, CreditType2
FROM            Credit
GO
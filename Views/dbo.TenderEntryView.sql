SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE VIEW [dbo].[TenderEntryView]
AS
SELECT     TenderEntryID, TenderID, TransactionID, TransactionType, Amount, Common1, Common2, Common3, Common4, Common5, Common6, TenderDate, 
                      Status, DateCreated, UserCreated, DateModified, UserModified
FROM         dbo.TenderEntry
GO
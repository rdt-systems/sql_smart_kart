SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO

CREATE procedure [dbo].[SP_GetTenderEntries]
(@TransactionID uniqueidentifier,
@Status int = 0)
as
SELECT dbo.TenderEntryView.*,Tender.SortOrder
FROM dbo.TenderEntryView
LEFT OUTER JOIN Tender ON Tender.TenderID=TenderEntryView.TenderID
WHERE (TenderEntryView.Status > @Status)
  AND (TransactionID=@TransactionID)
UNION
SELECT TenderEntryView.TenderEntryID, TenderEntryView.TenderID, 
@TransactionID as TransactionID, TenderEntryView.TransactionType, TenderEntryView.Amount,
TenderEntryView.Common1, TenderEntryView.Common2, TenderEntryView.Common3, TenderEntryView.Common4, TenderEntryView.Common5, TenderEntryView.Common6,
 TenderEntryView.TenderDate, TenderEntryView.Status, TenderEntryView.DateCreated, TenderEntryView.UserCreated, TenderEntryView.DateModified, TenderEntryView.UserModified,
Tender.SortOrder
FROM dbo.TenderEntryView
LEFT OUTER JOIN Tender ON Tender.TenderID=TenderEntryView.TenderID
WHERE (TenderEntryView.Status > @Status)
  AND TransactionID IN
    (SELECT TransactionID
     FROM PaymentDetails
     WHERE (Status > @Status)
       AND (TransactionPayedID = @TransactionID))
ORDER BY SortOrder
GO
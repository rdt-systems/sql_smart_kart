SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SP_GetTendersShift](
    @ShiftID uniqueidentifier,
    @TenderID Int=0,
    @IncludePayOut bit=1
)
as
IF @TenderID = 0
BEGIN
SELECT     TenderEntry.Amount, [Transaction].TransactionID, [Transaction].TransactionNo, [Transaction].StartSaleTime, Tender.TenderName, 
						  (CASE WHEN (Tender.TenderGroup = 3 OR
						  Tender.TenderGroup = 15 OR
						  Tender.TenderGroup = 14) THEN RIGHT(TenderEntry.Common1, 4) WHEN Tender.TenderGroup = 2 Or Tender.TenderGroup = 5 THEN TenderEntry.Common1 END) AS 'No'
	FROM         [Transaction] INNER JOIN
						  TenderEntry ON TenderEntry.TransactionID = [Transaction].TransactionID INNER JOIN
						  Tender ON TenderEntry.TenderID = Tender.TenderID
	WHERE     (RegShiftID = @ShiftID) AND ([Transaction].Status > 0) 
						  AND (TenderEntry.Status > 0)
END
ELSE
BEGIN
SELECT     TenderEntry.Amount, [Transaction].TransactionID, [Transaction].TransactionNo, [Transaction].StartSaleTime, Tender.TenderName, 
						  (CASE WHEN (Tender.TenderGroup = 3 OR
						  Tender.TenderGroup = 15 OR
						  Tender.TenderGroup = 14) THEN RIGHT(TenderEntry.Common1, 4) WHEN Tender.TenderGroup = 2 Or Tender.TenderGroup = 5 THEN TenderEntry.Common1 END) AS 'No'
	FROM         [Transaction] INNER JOIN
						  TenderEntry ON TenderEntry.TransactionID = [Transaction].TransactionID INNER JOIN
						  Tender ON TenderEntry.TenderID = Tender.TenderID
	WHERE     (RegShiftID = @ShiftID) AND ([Transaction].Status > 0) 
						  AND (TenderEntry.Status > 0)AND TenderGroup  = @TenderID
END
GO
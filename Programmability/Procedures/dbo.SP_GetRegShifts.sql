SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SP_GetRegShifts]
(@Filter nvarchar(4000),
 @IncludeReconcile Bit =0)

as
declare @MySelect nvarchar(4000)
if @IncludeReconcile = 0
BEGIN
  set @MySelect= ' SELECT  DISTINCT      RegShift.RegShiftID, RegShift.ShiftNO, RegShift.ShiftOpenDate, 
                         (CASE WHEN RegShift.Status = 1 THEN ''OPEN'' WHEN RegShift.Status = 3 THEN ''RECONCILE'' ELSE ''CLOSE'' END) AS Status, RegShift.ShiftCloseDate, 
                         Registers.RegisterNo, UPPER(Users.UserName) AS CloseBy, ISNULL(Trans.TransCount, 0) AS TransCount, (ISNULL(TotalExp.TotalExp, 0) + ISNULL(RegShift.OpeningAmount,0)) - ISNULL(P.Payout,0) AS TotalExp, 
                         ISNULL(TotalPick.TotalPick, 0) + ISNULL(RegShift.ClosingAmount,0) AS TotalPick,  ((ISNULL(TotalExp.TotalExp, 0) + ISNULL(RegShift.OpeningAmount,0)) - ISNULL(P.Payout,0))
                         - (ISNULL(TotalPick.TotalPick, 0) + ISNULL(RegShift.ClosingAmount,0)) AS Discrepancy 
FROM            RegShift INNER JOIN
                         Registers ON RegShift.RegID = Registers.RegisterID INNER JOIN
                             (SELECT        COUNT(*) AS TransCount, RegShiftID
                               FROM            [Transaction]
                               GROUP BY RegShiftID) AS Trans ON RegShift.RegShiftID = Trans.RegShiftID LEFT OUTER JOIN
                             (SELECT        SUM(TenderEntry.Amount) AS TotalExp, Transaction_1.RegShiftID
                               FROM            [Transaction] AS Transaction_1 INNER JOIN
                                                         TenderEntry ON Transaction_1.TransactionID = TenderEntry.TransactionID INNER JOIN
                                                         Tender ON TenderEntry.TenderID = Tender.TenderID
                               WHERE        (Transaction_1.Status > 0) AND (TenderEntry.Status > 0) AND (Tender.TenderGroup <> 6) AND (Tender.TenderGroup <> 7)AND (Tender.TenderGroup <> 13)
                               GROUP BY Transaction_1.RegShiftID) AS TotalExp ON RegShift.RegShiftID = TotalExp.RegShiftID LEFT OUTER JOIN
                             (SELECT        PayOut.RegShiftID, SUM(ISNULL(PayOut.Amount, 0)) AS Payout
                               FROM            PayOut INNER JOIN
                                                         TenderEntry ON PayOut.PayOutID = TenderEntry.TransactionID INNER JOIN
                                                         Tender ON TenderEntry.TenderID = Tender.TenderID
                               WHERE        (PayOut.Status > 0)
                               GROUP BY PayOut.RegShiftID) AS P ON RegShift.RegShiftID = P.RegShiftID LEFT OUTER JOIN
                             (SELECT        SUM(PickUpAmount) AS TotalPick, BatchID AS RegShiftID
                               FROM            BatchRec
                               GROUP BY BatchID) AS TotalPick ON RegShift.RegShiftID = TotalPick.RegShiftID LEFT OUTER JOIN
                         Users ON RegShift.CloseBy = Users.UserId
WHERE        (RegShift.Status > 0)'
END
ELSE BEGIN
		set @MySelect= ' SELECT  DISTINCT      RegShift.RegShiftID, RegShift.ShiftNO, RegShift.ShiftOpenDate, 
                         (CASE WHEN RegShift.Status = 1 THEN ''OPEN'' WHEN RegShift.Status = 3 THEN ''RECONCILE'' ELSE ''CLOSE'' END) AS Status, RegShift.ShiftCloseDate, 
                         Registers.RegisterNo, UPPER(Users.UserName) AS CloseBy, ISNULL(Trans.TransCount, 0) AS TransCount, (ISNULL(TotalExp.TotalExp, 0) + ISNULL(RegShift.OpeningAmount,0)) - ISNULL(P.Payout,0) AS TotalExp, 
                         ISNULL(TotalPick.TotalPick, 0) + ISNULL(RegShift.ClosingAmount,0) AS TotalPick,  ((ISNULL(TotalExp.TotalExp, 0) + ISNULL(RegShift.OpeningAmount,0)) - ISNULL(P.Payout,0))
                         - (ISNULL(TotalPick.TotalPick, 0) + ISNULL(RegShift.ClosingAmount,0)) AS Discrepancy 
FROM            RegShift INNER JOIN
                         Registers ON RegShift.RegID = Registers.RegisterID INNER JOIN
                             (SELECT        COUNT(*) AS TransCount, RegShiftID
                               FROM            [Transaction]
                               GROUP BY RegShiftID) AS Trans ON RegShift.RegShiftID = Trans.RegShiftID LEFT OUTER JOIN
                             (SELECT        SUM(TenderEntry.Amount) AS TotalExp, Transaction_1.RegShiftID
                               FROM            [Transaction] AS Transaction_1 INNER JOIN
                                                         TenderEntry ON Transaction_1.TransactionID = TenderEntry.TransactionID INNER JOIN
                                                         Tender ON TenderEntry.TenderID = Tender.TenderID
                               WHERE        (Transaction_1.Status > 0) AND (TenderEntry.Status > 0) AND (Tender.TenderGroup <> 6) AND (Tender.TenderGroup <> 7)AND (Tender.TenderGroup <> 13)
                               GROUP BY Transaction_1.RegShiftID) AS TotalExp ON RegShift.RegShiftID = TotalExp.RegShiftID LEFT OUTER JOIN
                             (SELECT        PayOut.RegShiftID, SUM(ISNULL(PayOut.Amount, 0)) AS Payout
                               FROM            PayOut INNER JOIN
                                                         TenderEntry ON PayOut.PayOutID = TenderEntry.TransactionID INNER JOIN
                                                         Tender ON TenderEntry.TenderID = Tender.TenderID
                               WHERE        (PayOut.Status > 0)
                               GROUP BY PayOut.RegShiftID) AS P ON RegShift.RegShiftID = P.RegShiftID LEFT OUTER JOIN
                             (SELECT        SUM(PickUpAmount) AS TotalPick, BatchID AS RegShiftID
                               FROM            BatchRec
                               GROUP BY BatchID) AS TotalPick ON RegShift.RegShiftID = TotalPick.RegShiftID LEFT OUTER JOIN
                         Users ON RegShift.CloseBy = Users.UserId
WHERE        (RegShift.Status > 0)'
END
Print (@MySelect + @Filter )
Execute (@MySelect + @Filter )
GO
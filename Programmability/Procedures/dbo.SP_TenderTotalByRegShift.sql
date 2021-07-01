SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SP_TenderTotalByRegShift]
(@RegShiftID uniqueidentifier)
As 

IF (SELECT COUNT(1) From SetUpValues where OptionID = 942 And OptionValue =1) >0
BEGIN
SELECT        SumTender.SortOrder, SumTender.RegShiftID, SumTender.Amount, SumTender.TenderName + ' ' + ISNULL(SumTender.CardName, '') AS TenderName, RegShift.ShiftNO, RegShift.ShiftOpenDate, 
                         RegShift.ShiftCloseDate, SumTender.TenderGroup, Users.UserName, SumPayOut.SumPayOut, ISNULL(SumTender.CountTender, 0) AS CountTender, RegShift.OpeningAmount
FROM            RegShift INNER JOIN
                             (SELECT        Tender.TenderName, SUM(TenderEntry.Amount) AS Amount, [Transaction].RegShiftID, Tender.SortOrder, Tender.TenderGroup, COUNT(TenderEntry.TenderEntryID) AS CountTender, 
                                                         (CASE WHEN TenderEntry.Common3 = '1' THEN 'Master' WHEN TenderEntry.Common3 = '2' THEN 'VISA' WHEN TenderEntry.Common3 = '4' THEN 'AmExp' WHEN TenderEntry.Common3 = '3' THEN
                                                          'Discover' ELSE '' END) AS CardName, [Transaction].TransactionID 
                               FROM            [Transaction] INNER JOIN
                                                         TenderEntry ON [Transaction].TransactionID = TenderEntry.TransactionID INNER JOIN
                                                         Tender ON TenderEntry.TenderID = Tender.TenderID
                               WHERE        ([Transaction].Status > 0)
                               GROUP BY Tender.SortOrder, Tender.TenderName, [Transaction].RegShiftID, Tender.TenderGroup, TenderEntry.Common3,[Transaction].TransactionID) AS SumTender ON RegShift.RegShiftID = SumTender.RegShiftID LEFT OUTER JOIN
                             (SELECT        SUM(Amount) AS SumPayOut, RegShiftID
                               FROM            PayOut
                               WHERE        (Status > 0)
                               GROUP BY RegShiftID) AS SumPayOut ON RegShift.RegShiftID = SumPayOut.RegShiftID LEFT OUTER JOIN
                         Users ON RegShift.CloseBy = Users.UserId
WHERE        (SumTender.RegShiftID = @RegShiftID)
END
ELSE BEGIN
	Select
		SumTender.SortOrder,
		SumTender.RegShiftID,
		SumTender.Amount,
		SumTender.TenderName + ' ' + IsNull(SumTender.CardName, '') As TenderName,
		RegShift.ShiftNO,
		RegShift.ShiftOpenDate,
		RegShift.ShiftCloseDate,
		SumSale.SumTax,
		SumSale.SumSale,
		SumSale.SumPay,
		SumTender.TenderGroup,
		Users.UserName,
		SumPayOut.SumPayOut,
		IsNull(SumTender.CountTender, 0) As CountTender,
		SumSale.TransCount,
		SumCustomer.CountCustomer,
		SumItemsQty.SumItemQty,
		-IsNull(Returns.RetureTotal, 0) As RetureTotal,
		-IsNull(Returns.RetuenQty, 0) As RetuenQty,
		RegShift.OpeningAmount,
		(SumSale.SumSale / SumSale.TransCount) As AvrgSale,
		(SumItemsQty.SumItemQty / SumSale.TransCount) As AvrgQty,
		IsNull(SumTender.ShowOnShift,1)As ShowOnShift
	From
		RegShift Inner Join
		(Select
			 Tender.TenderName,
			 Sum(TenderEntry.Amount) As Amount,
			 Tender.SortOrder,
			 Tender.TenderGroup,
			 Count(TenderEntry.TenderEntryID) As CountTender,
			 (Case
				 When TenderEntry.Common3 = '1'
				 Then 'Master'
				 When TenderEntry.Common3 = '2'
				 Then 'VISA'
				 When TenderEntry.Common3 = '4'
				 Then 'AmExp'
				 When TenderEntry.Common3 = '3'
				 Then 'Discover'
				 Else ''
			 End) As CardName,
			 Trans.RegShiftID,
			 Tender.ShowOnShift
		 From
			 TenderEntry Inner Join
			 Tender On TenderEntry.TenderID = Tender.TenderID Inner Join
			 (Select
				  [Transaction].RegShiftID,
				  [Transaction].TransactionID
			  From
				  [Transaction]
			  Where
				  [Transaction].Status > 0
			  Union
			  Select
				  PayOut.RegShiftID,
				  PayOut.PayOutID
			  From
				  PayOut
			  Where
				  PayOut.Status > 0) As Trans On TenderEntry.TransactionID = Trans.TransactionID
		 Where
			 TenderEntry.Status > 0
		 Group By
			 Tender.TenderName,
			 Tender.SortOrder,
			 Tender.TenderGroup,
			 Trans.RegShiftID,
			 TenderEntry.Common3,
			 Tender.ShowOnShift) As SumTender On RegShift.RegShiftID = SumTender.RegShiftID Inner Join
		(Select
			 Transaction_1.RegShiftID,
			 Sum(Transaction_1.Tax) As SumTax,
			 Sum(Transaction_1.Debit) As SumSale,
			 Sum(Transaction_1.Credit) As SumPay,
			 Count(Transaction_1.TransactionID) As TransCount
		 From
			 [Transaction] As Transaction_1
		 Where
			 Transaction_1.Status > 0
		 Group By
			 Transaction_1.RegShiftID) As SumSale On RegShift.RegShiftID = SumSale.RegShiftID Left Outer Join
		(Select
			 Sum(TransactionEntry_1.Qty) As RetuenQty,
			 Sum(TransactionEntry_1.Total) As RetureTotal,
			 Transaction_2.RegShiftID
		 From
			 TransactionEntry As TransactionEntry_1 Inner Join
			 [Transaction] As Transaction_2 On TransactionEntry_1.TransactionID = Transaction_2.TransactionID
		 Where
			 Transaction_2.Status > 0 And
			 TransactionEntry_1.Status > 0 And
			 TransactionEntry_1.Qty < 0
		 Group By
			 Transaction_2.RegShiftID) As Returns On RegShift.RegShiftID = Returns.RegShiftID Left Outer Join
		(Select
			 Count(Transaction_2.CustomerID) As CountCustomer,
			 Transaction_2.RegShiftID
		 From
			 [Transaction] As Transaction_2
		 Where
			 Transaction_2.Status > 0
		 Group By
			 Transaction_2.RegShiftID) As SumCustomer On RegShift.RegShiftID = SumCustomer.RegShiftID Left Outer Join
		(Select
			 Sum(TransactionEntry.Qty) As SumItemQty,
			 Transaction_3.RegShiftID
		 From
			 TransactionEntry Inner Join
			 [Transaction] As Transaction_3 On TransactionEntry.TransactionID = Transaction_3.TransactionID
		 Where
			 Transaction_3.Status > 0 And
			 TransactionEntry.TransactionEntryType = 0
		 Group By
			 Transaction_3.RegShiftID) As SumItemsQty On RegShift.RegShiftID = SumItemsQty.RegShiftID Left Outer Join
		(Select
			 Sum(PayOut.Amount) As SumPayOut,
			 PayOut.RegShiftID
		 From
			 PayOut
		 Where
			 PayOut.Status > 0
		 Group By
			 PayOut.RegShiftID) As SumPayOut On RegShift.RegShiftID = SumPayOut.RegShiftID Left Outer Join
		Users On RegShift.CloseBy = Users.UserId
	Where
		(SumTender.RegShiftID = @RegShiftID)
END
GO
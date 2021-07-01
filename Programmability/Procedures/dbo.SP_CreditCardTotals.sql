SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO



CREATE PROCEDURE [dbo].[SP_CreditCardTotals]
@from_date datetime,
@to_date datetime,
@StoreID uniqueidentifier

AS
	
Begin

SELECT SUM(CASE WHEN TE.Amount < 0 THEN TE.Amount ELSE 0 END) AS Credits, SUM(CASE WHEN TE.Amount >= 0 THEN TE.Amount ELSE 0 END) AS Sales , 
(case when TE.Common3 = 1 then 'Master Card' when TE.Common3 = 2 Then 'Visa' when TE.Common3 = 3 Then 'Discover' when TE.Common3 = 4 Then 'Amex'  else Tender.TenderName end) As CardType 
FROM   TenderEntry TE INNER JOIN Tender ON TE.TenderID = Tender.TenderID INNER JOIN [Transaction] ON TE.TransactionID = [Transaction].TransactionID
WHERE  [Transaction].StoreID = @StoreID and [Transaction].StartSaleTime>=@From_Date 
       and [Transaction].StartSaleTime<=@To_Date
       and [Transaction].Status>0
       and Te.TransactionType=0 
       and Te.Status>0 
 and (Tender.TenderName = 'CREDIT CARD' Or Tender.TenderName = 'DEBIT' Or Tender.TenderName = 'EBT' or Tender.TenderName = 'EBT CASH')
group by TE.Common3, Tender.TenderName 





--EBT 15
--Credit 3
---Debit 14
--EBT cash 16

--1	Master Card
--2	Visa
--3	Discover
--4	AMEX


END
GO
SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO



CREATE VIEW [dbo].[TransactionEntryQty]
WITH SCHEMABINDING
AS
	SELECT  
		transactionentryid,
		Qty,
		TransactionEntry.ItemStoreID,
		--CAST(StartSaleTime as VARCHAR(11))
		StartSaleTime, EndSaleTime
		 --cast(Cast(year(StartSaleTime )as nvarchar)+'-'
			--	+Cast(Month(StartSaleTime )as nvarchar)+'-'
			--	+Cast(Day(StartSaleTime )as nvarchar) as DateTime ) StartSaleTime 
		--COUNT_BIG(*) Cnt
    FROM            
		dbo.TransactionEntry 
		INNER JOIN dbo.[Transaction] ON TransactionEntry.TransactionID = [Transaction].TransactionID
	WHERE        
		(TransactionEntry.Status > 0) AND ([Transaction].Status > 0)-- AND (dbo.GetDay(Transaction_1.StartSaleTime) > DATEADD(DAY, - 3, dbo.GetLocalDATE()))
	--GROUP BY transactionentryid,
	--TransactionEntry.ItemStoreID, qty--,StartSaleTime
GO
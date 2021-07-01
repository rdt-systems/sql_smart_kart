SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE procedure [dbo].[UpdateMYPTDAveS]
(@WeekSDate DateTime,
 @WeekEDate DateTime,
 @MonthSDate DateTime,
 @MonthEDate DateTime)
as
declare @StartDate as DateTime
declare @EndDate as DateTime

SET @StartDate =@WeekSDate
SET @EndDate =@WeekEDate
  
UPDATE dbo.ItemStore
SET    MTDQty = isnull(
				(select sum(ISNULL(Qty,0))
				 from TransactionEntry 
				 inner join [Transaction] on TransactionEntry.TransactionID=[Transaction].TransactionID
				 where ItemStoreID=ItemStore.ItemStoreID and TransactionEntry.Status>0 and 
				 (dbo.GetDay([Transaction].StartSaleTime)>=@StartDate) AND (dbo.GetDay([Transaction].StartSaleTime)<=@EndDate) and [Transaction].Status>0 --and TransactionEntryType<>2
)
				,0),
	   MTDDollar =isnull(
				(select sum(ISNULL(Total,0))
				 from TransactionEntry 
				 inner join [Transaction] on TransactionEntry.TransactionID=[Transaction].TransactionID
				 where ItemStoreID=ItemStore.ItemStoreID and TransactionEntry.Status>0 and (dbo.GetDay([Transaction].StartSaleTime)>=@StartDate AND (dbo.GetDay([Transaction].StartSaleTime))<=@EndDate)  
and [Transaction].Status>0 
--and TransactionEntryType<>2
)
				,0),
--	   PTDReturnQty =isnull(
--				(select abs(sum(ISNULL(Qty,0)))
--				 from TransactionEntry 
--				 inner join [Transaction] on TransactionEntry.TransactionID=[Transaction].TransactionID
--				 where ItemStoreID=ItemStore.ItemStoreID and TransactionEntry.Status>0 and (dbo.GetDay([Transaction].StartSaleTime)>=@StartDate AND (dbo.GetDay([Transaction].StartSaleTime))<=@EndDate)  and [Transaction].Status>0 and TransactionEntryType=2)
--				,0),
	   DateModified=dbo.GetLocalDATE()


SET @StartDate =@MonthSDate
SET @EndDate  =@MonthEDate
  
UPDATE dbo.ItemStore
SET    PTDQty = isnull(
				(select sum(ISNULL(Qty,0))
				 from TransactionEntry 
				 inner join [Transaction] on TransactionEntry.TransactionID=[Transaction].TransactionID
				 where ItemStoreID=ItemStore.ItemStoreID and TransactionEntry.Status>0 and (dbo.GetDay([Transaction].StartSaleTime)>=@StartDate) AND (dbo.GetDay([Transaction].StartSaleTime)<=@EndDate) and [Transaction].Status>0 and TransactionEntryType<>2)
				,0),
	   PTDDollar =isnull(
				(select sum(ISNULL(Total,0))
				 from TransactionEntry 
				 inner join [Transaction] on TransactionEntry.TransactionID=[Transaction].TransactionID
				 where ItemStoreID=ItemStore.ItemStoreID and TransactionEntry.Status>0 and (dbo.GetDay([Transaction].StartSaleTime)>=@StartDate) AND (dbo.GetDay([Transaction].StartSaleTime)<=@EndDate) and [Transaction].Status>0 --and TransactionEntryType<>2
)
				,0),
	   MTDReturnQty =isnull(
				(select abs(sum(ISNULL(Qty,0)))
				 from TransactionEntry 
				 inner join [Transaction] on TransactionEntry.TransactionID=[Transaction].TransactionID
				 where ItemStoreID=ItemStore.ItemStoreID and TransactionEntry.Status>0 and (dbo.GetDay([Transaction].StartSaleTime)>=@StartDate) AND (dbo.GetDay([Transaction].StartSaleTime)<=@EndDate) and [Transaction].Status>0 --and TransactionEntryType=2
)
				,0),
	   DateModified=dbo.GetLocalDATE()

Declare @LastYTD datetime
set @LastYTD=(select Top(1) CAST(OptionValue as DateTime)
			  from   SetUpValues
			  where  OptionID=802)
if YEAR(@LastYTD)<>YEAR(dbo.GetLocalDATE())
BEGIN
UPDATE dbo.ItemStore
SET    YTDQty = isnull(
				(select sum(ISNULL(Qty,0))
				 from TransactionEntry 
				 inner join [Transaction] on TransactionEntry.TransactionID=[Transaction].TransactionID
				 where ItemStoreID=ItemStore.ItemStoreID and TransactionEntry.Status>0 and YEAR([Transaction].StartSaleTime)=YEAR(dbo.GetLocalDATE()) and [Transaction].Status>0 and TransactionEntryType<>2)
				,0),
	   YTDDollar =isnull(
				(select sum(ISNULL(Total,0))
				 from TransactionEntry 
				 inner join [Transaction] on TransactionEntry.TransactionID=[Transaction].TransactionID
				 where ItemStoreID=ItemStore.ItemStoreID and TransactionEntry.Status>0 and YEAR([Transaction].StartSaleTime)=YEAR(dbo.GetLocalDATE()) and [Transaction].Status>0 and TransactionEntryType<>2)
				,0),
	   YTDReturnQty =isnull(
				(select abs(sum(ISNULL(Qty,0)))
				 from TransactionEntry 
				 inner join [Transaction] on TransactionEntry.TransactionID=[Transaction].TransactionID
				 where ItemStoreID=ItemStore.ItemStoreID and TransactionEntry.Status>0 
and YEAR([Transaction].StartSaleTime)=YEAR(dbo.GetLocalDATE()) and [Transaction].Status>0 and TransactionEntryType=2)
				,0),
	   DateModified=dbo.GetLocalDATE()

UPDATE SetUpValues
SET OptionValue=dbo.FormatDateTime(dbo.GetLocalDATE(),'YYYYMMDD')
WHERE OptionID=802 

END
GO
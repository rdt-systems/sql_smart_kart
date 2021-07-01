SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SP_GetTendersCashierTotal]

(
    @StoreID uniqueidentifier,
    @FromDate DateTime,
    @ToDate DateTime,
    @IncludePayOut bit=1,
	@Hebrew bit =0
)
as
SET FMTONLY OFF;

/*------------------------------------------------------------------------------
Description: This procedure extracts the data for tender report.
Returned columns: TransactionType, [Type], Amount, TenderType,
                  Cashier, CreditType, TransactionID, TransactionNo,
                  TenderDate, RegistersBackoffice, StoreID
Return value: ?
------------------------------------------------------------------------------*/

declare @IsHeb as bit
set @IsHeb=0--(Select OptionValue from SetupValues where OptionName='Language' And  StoreID ='00000000-0000-0000-0000-000000000000')


--get a list of Tenders (handle hebrew localization)
create table #CurrTender(
    TenderID int NOT NULL,
    TenderType int NULL,
    TenderName nvarchar(50) --COLLATE Hebrew_CI_AS NULL
)
IF @Hebrew = 1 
ALTER TABLE #CurrTender ALTER COLUMN TenderName nvarchar(50) COLLATE Hebrew_CI_AS NULL
insert into #CurrTender(TenderID, TenderType, TenderName)
 select TEnderID, TenderType, (case when @IsHeb=0 then TenderName else TenderNameHe end) as TenderName
 from Tender
 --where TEnderType<>1 

--get a list of system values (handle hebrew localization)
create table #CurrSystemValues(
    SystemTableNo bigint NOT NULL,
    SystemValueNo int NOT NULL,
    SystemValueName nvarchar(50) --COLLATE HEBREW_CI_AS
)
IF @Hebrew = 1 
ALTER TABLE #CurrSystemValues ALTER COLUMN SystemValueName nvarchar(50) COLLATE Hebrew_CI_AS
insert into #CurrSystemValues(SystemTableNo, SystemValueNo, SystemValueName)
 select SystemTableNo, SystemValueNo, (case when @IsHeb=0 then SystemValueName else SystemValueNameHe end) as SystemValueName
 from SystemValues

create table #Tepm1(
    TransactionType int,
    [Type] int,
    Amount money,
    TenderType nvarchar(50) --COLLATE Hebrew_CI_AS
	,
    Cashier nvarchar(50) ,
    CreditType nvarchar(50) ,
    TransactionID uniqueidentifier,
	CustomerID uniqueidentifier NULL,
    TransactionNo nvarchar(50) ,
    TenderDate datetime,
    RegistersBackoffice int,
    StoreID uniqueidentifier ,
	TenderTypeInt int
)
IF @Hebrew = 1
BEGIN 
ALTER TABLE #Tepm1 ALTER COLUMN TenderType nvarchar(50) COLLATE Hebrew_CI_AS
ALTER TABLE #Tepm1 ALTER COLUMN Cashier nvarchar(50) COLLATE Hebrew_CI_AS
ALTER TABLE #Tepm1 ALTER COLUMN CreditType nvarchar(50) COLLATE Hebrew_CI_AS
ALTER TABLE #Tepm1 ALTER COLUMN TransactionNo nvarchar(50) COLLATE Hebrew_CI_AS
END
--extract tender etries & transaction details for selected period only
create table #tentry(
    TenderID int, 
    Amount money,
    UserCreated uniqueidentifier,
    Common3 nvarchar(50),
    TransactionID uniqueidentifier,
	CustomerID  uniqueidentifier  NULL,
    BatchID uniqueidentifier, 
    StoreID uniqueidentifier,
    TransactionNo nvarchar(50),
    EndSaleTime datetime,
    RegisterTransaction bit
)
insert into #tentry
 select TenderEntry.TenderID, TenderEntry.Amount, TenderEntry.UserCreated, 
        TenderEntry.Common3, [Transaction].TransactionID, [Transaction].CustomerID,
        [Transaction].BatchID, [Transaction].StoreID, [Transaction].TransactionNo, 
        [Transaction].EndSaleTime, [Transaction].RegisterTransaction 
 from [Transaction]
 inner join TenderEntry on TenderEntry.TransactionID=[Transaction].TransactionID
 where [Transaction].EndSaleTime>=@FromDate 
       and [Transaction].EndSaleTime<=@ToDate
       and [Transaction].Status>0
       and TEnderEntry.TransactionType=0 
       and TEnderEntry.Status>0 
 
--extract data for TransactionType=Transaction
insert into #Tepm1
 select 0 as TransactionType,
        #CurrTender.TenderType as [Type],
        #tentry.Amount,
        #CurrTender.TenderName as TenderType ,
        isnull(createUser.UserName, cashierUser.UserName) as Cashier,
        SysVisa.SystemValueName as CreditType,
        #tentry.TransactionID,
		#tentry.CustomerID,
        #tentry.TransactionNo,
        #tentry.EndSaleTime as TenderDate,
        case when #tentry.RegisterTransaction=1 then 1 else 0 end as RegistersBackoffice,
        #tentry.StoreID,
		#CurrTender.TenderType
 from #CurrTender
 inner join #tentry on #tentry.TenderID=#CurrTender.TenderID
 left outer join Batch on Batch.BatchID=#tentry.BatchID 
 left outer join Users cashierUser on cashierUser.UserId=Batch.CashierID 
 left outer join Users createUser on createUser.UserId=#tentry.UserCreated 
 left outer join #CurrSystemValues SysVisa on CAST(SysVisa.SystemValueNo AS nvarchar) =#tentry.Common3 and SysVisa.SystemTableNo=5 and #tentry.TenderID=3       

--extract tender etries for PayOut and CashCheck transactions
create table #tentryCP(
    TenderID int, 
    Amount money,
    TransactionID uniqueidentifier, 
    TransactionType int
)
insert into #tentryCP
 select TenderID, Amount, TransactionID, TransactionType
 from TenderEntry
 where TransactionType>0 
       and TEnderEntry.Status>0 
 
--extract data for TransactionType=Pay Out
if @IncludePayOut = 1  begin
	insert into #Tepm1
	 select 1 as TransactionType,
			2 as [Type],
			sum(#tentryCP.Amount) as Amount,
			(select TenderName from #CurrTender where TenderID=#tentryCP.TenderID) as TenderType,
			Users.UserName as Cashier,
			null as CreditType,
			#tentryCP.TransactionID,
			NULL AS CustomerID,
			'Payout' as TransactionNo,
			PayOut.PayOutDate as TenderDate,
			1,
			Registers.StoreID,
			(select TenderType from #CurrTender where TenderID=#tentryCP.TenderID) as TenderType
	 from PayOut
	 inner join Registers on Registers.RegisterID = PayOut.RegisterID
	 inner join #tentryCP on #tentryCP.TransactionID =PayOut.PayOutID 
	 left outer join Users on Users.UserId=PayOut.ChasierID 
	 where #tentryCP.TransactionType=1 
		   and PayOut.PayOutDate>@FromDate 
		   and PayOut.PayOutDate<@ToDate
	 group by Users.UserId, Users.UserName, PayOut.PayOutDate, #tentryCP.TransactionID, Registers.StoreID,#tentryCP.TenderID
end

--extract data for TransactionType=Cash Check
insert into #Tepm1
 select 2 as TransactionType,
        2 as [Type],
        sum(#tentryCP.Amount) as Amount,
        (select TenderName From #CurrTender where TenderID=1) as TenderType,
        Users.UserName as Cashier ,
        null as CreditType,
        #tentryCP.TransactionID,
		NULL AS CustomerID,
        'CashCheck' as TransactionNo,
        CashCheck.Date as TenderDate,
        1,
        Batch.StoreID,
		  (select TenderType From #CurrTender where TenderID=1) as TenderType
 from CashCheck
 inner join Batch on Batch.BatchID=CashCheck.BatchID
 inner join #tentryCP on #tentryCP.TransactionID=CashCheck.CashCheckID 
 left outer join Users on Users.UserId=CashCheck.UserID 
 where #tentryCP.TenderID=1 
       and #tentryCP.TransactionType=2 
       and CashCheck.Date>@FromDate 
       and CashCheck.Date<@ToDate
 group by Users.UserId, Users.UserName, CashCheck.Date, #tentryCP.TransactionID, Batch.StoreID

--extract data for TransactionType=Cash Check
insert into #Tepm1
 select 2 as TransactionType,
        2 as [Type],
        sum(#tentryCP.Amount) as Amount,
        (Select TenderName From #CurrTender where TenderID=2) as TenderType,
        Users.UserName as Cashier,
        null as CreditType,
        #tentryCP.TransactionID,
		NULL as CustomerID,
        'CashCheck' as TransactionNo,
        CashCheck.Date as TenderDate,
        1,
        Batch.StoreID,
		(Select TenderType From #CurrTender where TenderID=2) as TenderType
 from CashCheck
 inner join Batch on Batch.BatchID=CashCheck.BatchID
 inner join #tentryCP on #tentryCP.TransactionID=CashCheck.CashCheckID 
 left outer join Users on Users.UserId=CashCheck.UserID 
 where #tentryCP.TenderID=2 
       and #tentryCP.TransactionType=2 
       and CashCheck.Date>@FromDate
       and CashCheck.Date<@ToDate
 group by Users.UserId, Users.UserName, CashCheck.Date, #tentryCP.TransactionID, Batch.StoreID

--return results
select -- TransType.SystemValueName as TransactionType,
       --(select case when #CurrSystemValues.SystemValueName='Cash' then 'Actual Cash' else #CurrSystemValues.SystemValueName end) as [Type],
	  case when TransType.SystemValueName='Pay Out' then  TransType.SystemValueName else   #Tepm1.TenderType end COLLATE Hebrew_CI_AS   as TenderType ,
	  isnull(CreditType,'Other CC')AS CreditType,
       sum(Amount)as Amount,
       Store.StoreName,
	   TenderTypeInt , 
	   count(DISTINCT TransactionID)as Count,
	    case when TransType.SystemValueName='Pay Out'  then 99 else  Tender.SortOrder end as  SortOrder
 from #Tepm1 
 inner join Store on Store.StoreID=#Tepm1.StoreID  
 INNER JOIN Tender  ON Tender.TenderName =#Tepm1.TenderType 
 LEFT OUTER JOIN Customer AS C on #Tepm1.CustomerID = C.CustomerID
 left outer join #CurrSystemValues on #CurrSystemValues.SystemValueNo=[Type] and #CurrSystemValues.SystemTableNo=25 
 left outer join #CurrSystemValues TransType on TransType.SystemValueNo=#Tepm1.TransactionType and TransType.SystemTableNo=41 
 left outer join #CurrSystemValues LocationType on LocationType.SystemValueNo=#Tepm1.RegistersBackoffice and LocationType.SystemTableNo=40
 where (@StoreID ='00000000-0000-0000-0000-000000000000' or #Tepm1.StoreID=@StoreID)
 group by   case when TransType.SystemValueName='Pay Out' then  TransType.SystemValueName else   #Tepm1.TenderType end    ,
	  isnull(CreditType,'Other CC') ,Store.StoreName ,TenderTypeInt, case when TransType.SystemValueName='Pay Out'  then 99 else  Tender.SortOrder end 
 order by  case when TransType.SystemValueName='Pay Out'  then 99 else  Tender.SortOrder end
GO
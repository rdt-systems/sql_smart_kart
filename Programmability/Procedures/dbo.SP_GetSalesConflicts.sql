SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


----select * from sales
----
----select * from salesbaskets where saleid='DE1299C1-C104-42E1-A279-4E6B49BB2E05'
----
--ALTER Proc [dbo].[SP_GetSalesConflicts]
--(
--@ID nvarchar(4000),
--@Type int,
--@SaleID UniqueIdentifier,
--@StoreID Uniqueidentifier
--)
--as
--declare @SPText nvarchar(4000)
--set @SPText='
--SELECT distinct Sales.SaleID,SaleName,Priority,AllowMultiSales,Sales.DateCreated 
--FROM SalesBaskets  inner join Sales On Sales.SaleID=SalesBaskets.SaleID
--WHERE
--SalesBaskets.status>0 
--and Sales.Status>0 
--and SalesBaskets.SaleID<>''' + cast(@SaleID as nvarchar(400)) + ''' 
--and SalesBaskets.BaskItemID in ('
--
--execute (@SPText + @ID + ') ORDER BY Sales.DateCreated ')
--
---- ORDER BY Sales.DateCreated
----12651BF0-B391-4DCF-A7EB-3F49D53C2B9A
----6B7ACAE8-2AE4-4D3B-A036-9360392E2A75
----8C0498F0-A4B1-4291-85E2-32D926E060EB
----3f61936b-598e-46b1-bef4-c0b5995bc656
--
--
--declare @SaleID Uniqueidentifier
--Set @SaleID='3f61936b-598e-46b1-bef4-c0b5995bc656'
--declare @Multi int
--set @Multi=1

CREATE proc [dbo].[SP_GetSalesConflicts]
(
@ID nvarchar(4000),
@Type int,
@SaleID UniqueIdentifier,
@StoreID Uniqueidentifier,
@Multi int=2
)
as
declare @SPText1 nvarchar(4000)
declare @SPText2 nvarchar(4000)

set @SPText1='
SELECT distinct Sales.SaleID,SaleName,Priority,AllowMultiSales,Sales.DateCreated  Into #t
FROM SalesBaskets  inner join Sales On Sales.SaleID=SalesBaskets.SaleID
WHERE
SalesBaskets.status>0 
and Sales.Status>0 
and SalesBaskets.SaleID<> ''' + cast(@SaleID as nvarchar(400)) + '''
and SalesBaskets.BaskItemID in ('

set @SPText2='
)
and AllowMultiSales<' +  cast(@Multi as nvarchar(50)) + '

if exists (select * from #t
           where  exists(SELECT sales.saleid 
						 FROM SalesBaskets  inner join Sales On Sales.SaleID=SalesBaskets.SaleID
						 WHERE
						 SalesBaskets.status>0 
					 	 and Sales.Status>0 
					     and SalesBaskets.SaleID<>#t.saleid
						 and SalesBaskets.BaskItemID in (select baskitemid from salesbaskets where saleid=#t.saleid )
						 and sales.saleid not in (select saleid  from #t)
						 and sales.saleid<> ''' + cast(@SaleID as nvarchar(400)) + ''')
		   )
	 select * from #t where AllowMultiSales=1
	 union all
	 select distinct Sales.SaleID,SaleName,Priority,AllowMultiSales,Sales.DateCreated
	 FROM SalesBaskets  inner join Sales On Sales.SaleID=SalesBaskets.SaleID
	 WHERE
	 SalesBaskets.status>0 
	 and Sales.Status>0 
	 and SalesBaskets.SaleID<> ''' + cast(@SaleID as nvarchar(400)) + '''
	 and Priority >= (select min(Priority) from #t) 
	 and Priority <= (select max(Priority) from #t)
	 and AllowMultiSales=0
     order by DateCreated
else
	select * from #t
    order by DateCreated
drop table #t
'

execute (@SPText1 + @ID + @SPText2)
GO
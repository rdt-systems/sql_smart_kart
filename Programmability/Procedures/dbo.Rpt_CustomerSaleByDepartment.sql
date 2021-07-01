SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[Rpt_CustomerSaleByDepartment]
(
@Filter nvarchar(4000),
@Departments nvarchar(1000),
@FromAmount money,
@ToAmount money
)
AS
declare @MySelect nvarchar(3000)
Declare @MyWhere nvarchar(1000)
SET @MyWhere=''
if @Departments<>'' 
BEGIN
  SET @MyWhere ='AND (TransactionEntry.DepartmentID IN ('+@Departments+')) '
END

declare @S nvarchar(3000)
SET @S='WITH CTE AS
(   SELECT   DepartmentStoreID,ParentDepartmentID,Name, 0 [Level]
    FROM    DepartmentStore 
    UNION ALL
    SELECT  CTE.DepartmentStoreID,   DepartmentStore.ParentDepartmentID, CTE.Name, Level+1 
    FROM    CTE
            INNER JOIN DepartmentStore
                ON CTE.ParentDepartmentID = DepartmentStore.DepartmentStoreID
    WHERE   DepartmentStore.ParentDepartmentID IS NOT NULL AND DepartmentStore.ParentDepartmentID<>''00000000-0000-0000-0000-000000000000'' and Status >0 
) 

SELECT  c.DepartmentStoreID, c.Name, c.ParentDepartmentID into #ParentDepartment
FROM    (   SELECT  *, MAX([Level]) OVER (PARTITION BY Name) [MaxLevel]
            FROM    CTE
        ) c
WHERE   MaxLevel = Level 

'



SET @MySelect ='
select *
from  (
SELECT data.*,
       sum(TotalDepartment) OVER (PARTITION BY CustomerID)AS SUM
FROM
  (SELECT [Transaction].CustomerID,
          isnull(DepartmentStore.Name,''No Department'') AS Department,
          ISNULL(Parent.Name, ''No Department'')SubDepartment,
          SUM(TransactionEntry.Total) AS TotalDepartment,
          ISNULL(Customer.LastName, '''') + '' '' + ISNULL(Customer.FirstName, '''') AS FullNAME
   FROM TransactionEntry
    JOIN [Transaction] ON [Transaction].TransactionID = TransactionEntry.TransactionID
   JOIN Customer ON Customer.CustomerID=[Transaction].CustomerID
   LEFT OUTER JOIN itemstore ON itemstore.ItemStoreID=TransactionEntry.ItemStoreID
   LEFT OUTER
		  JOIN #ParentDepartment AS Parent ON Parent.DepartmentStoreID= isnull(itemstore.DepartmentID, TransactionEntry.DepartmentID)
   LEFT OUTER
	JOIN DepartmentStore ON DepartmentStore.DepartmentStoreID=isnull(Parent.ParentDepartmentID,Parent.DepartmentStoreID)
   WHERE 1=1
     AND (TransactionEntry.Status > 0)
     AND (TransactionEntry.TransactionEntryType <> 4)
     AND (TransactionEntry.TransactionEntryType <> 5)
     AND ([Transaction].Status > 0)'+
	 @Filter+
	 @MyWhere
   +'GROUP BY [Transaction].CustomerID,
            ISNULL(Customer.LastName, '''') + '' '' + ISNULL(Customer.FirstName, ''''),
            DepartmentStore.Name,
            Parent.Name
 ) AS DATA ) as DATASum

'+
 'where   SUM>='+CONVERT(nvarchar, @FromAmount, 0)+' and SUM <='+CONVERT(nvarchar, @ToAmount, 0)

print @S+@MySelect
exec(@S+ @MySelect)

if   OBJECT_ID('tempdb..#ParentDepartment') is not null drop table #ParentDepartment
GO
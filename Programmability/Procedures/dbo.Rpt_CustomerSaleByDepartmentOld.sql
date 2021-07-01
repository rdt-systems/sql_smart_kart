SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[Rpt_CustomerSaleByDepartmentOld] 
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
  SET @MyWhere ='AND (DepartmentID IN ('+@Departments+')) '
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
WHERE   MaxLevel = Level '

SET @MySelect ='SELECT distinct  TransactionEntryItem.CustomerID, IsNull(SumDepartment.Department,''No Department'')SubDepartment, 
SumDepartment.TotalDepartment,ISNULL(Customer.LastName,'''')+'' ''+ISNULL(Customer.FirstName,'''') AS FullNAME,  SumDepartment.ParentName AS Department
FROM  TransactionEntryItem INNER JOIN  (SELECT        SUM(TransactionEntryItem.ExtPrice) AS TotalDepartment, TransactionEntryItem.Department, TransactionEntryItem.CustomerID, 
                         TransactionEntryItem.DepartmentID,  Parent.ParentName
FROM            TransactionEntryItem  INNER JOIN
                             (SELECT        DepartmentStore.Name AS ParentName, Parent.DepartmentStoreID
                               FROM            DepartmentStore INNER JOIN
                                                             (SELECT        *
                                                               FROM            [#ParentDepartment]) AS Parent ON DepartmentStore.DepartmentStoreID = ISNULL(Parent.ParentDepartmentID, 
                                                         Parent.DepartmentStoreID)) AS Parent ON TransactionEntryItem.DepartmentID = Parent.DepartmentStoreID
WHERE        (1 = 1) '+@MyWhere+    @Filter+' AND (CustomerID IS NOT NULL)
GROUP BY TransactionEntryItem.Department, TransactionEntryItem.CustomerID, TransactionEntryItem.DepartmentID, Parent.ParentName) AS SumDepartment ON TransactionEntryItem.CustomerID = SumDepartment.CustomerID 
                            INNER JOIN Customer ON TransactionEntryItem.CustomerID = Customer.CustomerID
							INNER JOIN
                             (SELECT        CustomerID, SUM(Total) AS Total
                               FROM            TransactionEntryItem AS TransactionEntryItem_2
                               WHERE        (1 = 1)'+@Filter+' 
                               GROUP BY CustomerID) AS SumSale ON Customer.CustomerID = SumSale.CustomerID
WHERE  (TransactionEntryItem.CustomerID IS NOT NULL)'+@Filter +' AND  SumSale.Total >='+CONVERT(nvarchar, @FromAmount, 0)+' and SumSale.Total <='+CONVERT(nvarchar, @ToAmount, 0)+'
GROUP BY TransactionEntryItem.CustomerID, SumDepartment.Department, SumDepartment.TotalDepartment,Name,Customer.FirstName, Customer.LastName ,SumDepartment.ParentName'
--HAVING (SUM(TransactionEntryItem.ExtPrice) >= '+CONVERT(nvarchar, @FromAmount, 0)+')AND (SUM(TransactionEntryItem.ExtPrice) <='+CONVERT(nvarchar, @ToAmount, 0)+')

print @S+@MySelect
exec(@S+ @MySelect)

drop table #ParentDepartment
GO
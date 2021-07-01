SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO



CREATE PROCEDURE [dbo].[SP_TrackSales]
	@Filter nvarchar(4000),
	@ItemFilter nvarchar(4000)
	 
as
declare @MySQL nvarchar(4000)
declare @MyGroup nvarchar(300)
declare @MyFilter nvarchar(1000)
declare @ItemSelect nvarchar(500)
--Set  @ItemSelect='Select ItemStoreID 
--				  Into #ItemSelect 
--                  From ItemsRepFilter 
--                  Where (1=1) '


SET @MySQL = '    
SELECT  
	SUM(TotalAfterDiscount) as Total,
	ISNULL(ItemMainAndStoreView.name, ''[MANUAL ITEM]'') AS ItemName, 
	ISNULL(DepartmentStore.name,''[NO DEPARTMENT]'')as Department,
	store.StoreName
FROM            
	TransactionEntry 
	INNER JOIN [Transaction] ON [Transaction].TransactionID = TransactionEntry.TransactionID
	LEFT OUTER JOIN DepartmentStore ON TransactionEntry.DepartmentID = DepartmentStore.DepartmentStoreID 
	
	LEFT OUTER JOIN ItemMainAndStoreView ON ItemMainAndStoreView.ItemStoreID = TransactionEntry.ItemStoreID AND ItemMainAndStoreView.Status > - 1 
inner join store on store.StoreID =[Transaction].StoreID
	--LEFT OUTER JOIN
                             --(SELECT DISTINCT ItemID, Name AS ParentName, SupplierName, StoreNo, [Supplier Item Code]
                             --  FROM            ItemMainAndStoreView AS ItemMainAndStoreView_1) AS ParentInfo ON ItemMainAndStoreView.StoreNo = ParentInfo.StoreNo AND ItemMainAndStoreView.LinkNo = ParentInfo.ItemID
WHERE        
	(TransactionEntry.Status > 0) AND (TransactionEntry.TransactionEntryType <> 4) AND (TransactionEntry.TransactionEntryType <> 5) AND ([Transaction].Status > 0)

    '
			 
SET @MyFilter = 'and  (1=1) '+@Filter			
SET @MyGroup = ' group by ItemMainAndStoreView.[Name] , DepartmentStore.name, store.StoreName
 Order By DepartmentStore.[Name]'




PRINT ((  -- @ItemFilter + 
@MySQL + @MyFilter + @MyGroup))
exec(  --@ItemFilter +
 @MySQL + @MyFilter + @MyGroup)
GO
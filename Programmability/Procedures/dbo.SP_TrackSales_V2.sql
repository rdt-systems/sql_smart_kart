SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SP_TrackSales_V2]
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


SET @MySQL = ' select  sum(TotalAfterDiscount) as total, Im.[Name] as ItemName, isnull(ds.name,''[NO DEPARTMENT]'')as Department,StoreName
			  from [dbo].[TransactionEntry] te
			  inner join [transaction] t on te.TransactionID = t.TransactionID
			  inner join [dbo].[ItemsRepFilterDept] ir on te.ItemStoreID = ir.ItemStoreID
			  inner join DepartmentStore ds on ir.departmentid = ds.DepartmentStoreID
			 inner join dbo.itemstore ist on ist.ItemStoreID = te.ItemStoreID 
			inner join  dbo.itemMain im on im.itemid = ist.itemno
			inner join [dbo].[Store] s on t.StoreID = s.StoreID  '
			 
SET @MyFilter = 'where (1=1) '+@Filter			
SET @MyGroup = ' group by im.[Name] , ds.name, StoreName Order By im.[Name]'

PRINT (( @ItemFilter + @MySQL + @MyFilter + @MyGroup))
exec( @ItemFilter + @MySQL + @MyFilter + @MyGroup)
GO
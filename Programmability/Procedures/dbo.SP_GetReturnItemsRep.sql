SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SP_GetReturnItemsRep]
(@Filter nvarchar(4000),
 @ItemFilter nvarchar(4000),
 @CustomerFilter nvarchar(4000))

as
declare @MySelect nvarchar(4000)
declare @MyWhere nvarchar(4000)

declare @ItemSelect nvarchar(4000)
Set  @ItemSelect='Select Distinct ItemStoreID 
				  Into #ItemSelect 
                  From ItemsRepFilter 
                  Where (1=1)  '

if @CustomerFilter<>''

	begin 
		declare @CustomerSelect nvarchar(4000)
		Set  @CustomerSelect=' Select Distinct CustomerID 
							  Into #CustomerSelect 
							  From CustomerRepFilter 
							  Where (1=1) '
		SET @MyWhere=	' where dbo.TransactionEntryView.Status>0 AND ((TransactionEntryView.TransactionEntryType = 2 AND TransactionEntryView.Qty <> 0)OR QTY<0) And exists (Select 1 From #ItemSelect where ItemStoreID=TransactionEntryView.ItemStoreID) And  exists (Select 1 From #CustomerSelect where CustomerID=TransactionEntryView.CustomerID ) '
	end 
 
ELSE
	SET @MyWhere=	' where dbo.TransactionEntryView.Status>0 AND ((TransactionEntryView.TransactionEntryType = 2 AND TransactionEntryView.Qty <> 0)OR QTY<0)  And exists (Select 1 From #ItemSelect where ItemStoreID=TransactionEntryView.ItemStoreID) '

set @MySelect=
'SELECT     IsNull(dbo.TransactionEntryView.ItemID,''00000000-0000-0000-0000-000000000000'')As ItemID,
           isnull(dbo.TransactionEntryView.Name,''[MANUAL ITEM]'')As Name, 
		   dbo.TransactionEntryView.ModalNumber,  
		   dbo.TransactionEntryView.ModalNumber,
		   dbo.TransactionEntryView.ItemCode,
		   Sum(isnull(Qty,0)) as Qty,
		   Sum(isnull(Total,0)) as Amount,dbo.Supplier.Name as SuppName,
		   TransactionEntryView.Note AS ReturnReason,
		   --dbo.SystemValues.SystemValueName as ReturnReason,
		   dbo.TransactionEntryView.ItemStoreID,
		   dbo.[Transaction].StoreID,
           max(TransactionEntryView.Price) as Price,
           max(TransactionEntryView.OnHand) as OnHand, ISNULL(Dep.Name,''[NO Department]'') AS Department
FROM         dbo.TransactionEntryView inner JOIN
             dbo.[Transaction] On dbo.TransactionEntryView.TransactionID = dbo.[Transaction].TransactionID Left Outer JOIN
			 (SELECT DepartmentStoreID, Name From  DepartmentStore) AS Dep ON TransactionEntryView.DepartmentID = Dep.DepartmentStoreID LEFT OUTER JOIN
			 dbo.SystemValues ON  dbo.TransactionEntryView.ReturnReason = dbo.SystemValues.SystemValueNo and dbo.SystemValues.SystemTableNo = 29 Left Outer JOIN
			 dbo.ItemSupply  ON  dbo.TransactionEntryView.ItemStoreID = dbo.ItemSupply.ItemStoreNo and dbo.ItemSupply.Status >0 and dbo.ItemSupply.IsMainSupplier =1  Left Outer Join
			 dbo.Supplier  ON  dbo.ItemSupply.SupplierNo=dbo.Supplier.SupplierID and dbo.ItemSupply.Status >0 and dbo.ItemSupply.IsMainSupplier =1  
'


Declare @MyGroupBy nvarchar(4000)
set @MyGroupBy=' group by   dbo.TransactionEntryView.ItemID,
                            dbo.TransactionEntryView.Name,
							dbo.TransactionEntryView.ModalNumber,
							dbo.TransactionEntryView.ItemCode,
							TransactionEntryView.Note,
							dbo.SystemValues.SystemValueName,
							dbo.Supplier.Name,
							dbo.TransactionEntryView.ItemStoreID,
							dbo.[Transaction].StoreID,
							Dep.Name '
print (@ItemSelect  + @MySelect + @MyWhere + @Filter + @MyGroupBy) 
Execute (@ItemSelect + @ItemFilter + @CustomerSelect + @CustomerFilter + @MySelect + @MyWhere + @Filter + @MyGroupBy)
GO
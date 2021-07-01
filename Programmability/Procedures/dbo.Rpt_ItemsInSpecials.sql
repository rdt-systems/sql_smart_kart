SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO

CREATE procedure [dbo].[Rpt_ItemsInSpecials] 
(@Filter nvarchar(4000),
@ItemFilter nvarchar(4000),
@CustomerFilter nvarchar(4000)
)
as

declare @MyWhere nvarchar(4000)
Declare @MyIndex nvarchar(4000)
declare @ItemSelect nvarchar(4000)
Set  @ItemSelect='Select ItemStoreID 
				  Into #ItemSelect 
                  From dbo.ItemsRepFilter 
                  Where (1=1) '

Set @MyIndex = 'CREATE NONCLUSTERED INDEX [#Tem_Index_Temp_Table]
ON [dbo].[#ItemSelect] ([ItemStoreID])'

if @CustomerFilter<>''

	begin 
		declare @CustomerSelect nvarchar(4000)
		Set  @CustomerSelect=' Select CustomerID 
							   Into #CustomerSelect 
							   From dbo.CustomerRepFilter 
							   Where (1=1) '
		SET @MyWhere=	' where RegUnitPrice<>UOMPrice  And  exists (Select 1 From #CustomerSelect where CustomerID=transactionentryitem.CustomerID ) '
	SET @MyWhere=	' where RegUnitPrice<>UOMPrice  '
	end 
 
ELSE
	SET @MyWhere=	' where RegUnitPrice<>UOMPrice  '

--*********************************************


declare @Sel1 nvarchar(4000)
declare @Sel2 nvarchar(4000)


IF (Select COUNT(*) from SetUpValues where OptionID = 100 and ((OptionValue = '1') or(OptionValue = 'True')) And StoreID <> '00000000-0000-0000-0000-000000000000') >0
set @Sel1='
SELECT   
		 MainDepartment,
		 SubDepartment,
         SubSubDepartment,
		 Department,
		 [Name],
		 BarcodeNumber,
		 ModalNumber, 
		 TransactionEntryItem.ItemStoreID, 
		 ItemID, 
		 BarcodeNumber,

         SUM(QtyCase) AS QtyCase,
		 SUM(Qty) AS Qty,
	     SUM(ExtCost) as ExtCost,
		 SUM(Total) as ExtSpecialPrice,
		 SUM(RegUnitPrice*Qty) as ExtRegularPrice,

		(CASE WHEN SUM(TotalAfterDiscount)= 0 then 0
		      ELSE SUM(Profit)/ SUM(TotalAfterDiscount)
         END)
	     as MarginPrice,

         (CASE WHEN SUM(ExtCost) <> 0 then
		     SUM(Profit)/ SUM(ExtCost)
         ELSE 0
		 END) as MarkupPrice,

		 SUM(Profit) as Profit,
		
		 SUM(RegUnitPrice*Qty)-
		 (SUM(ExtCost)+SUM(Discount))
		 as RegularProfit,

         SUM(Discount) as Discount,
         SUM(TotalAfterDiscount) as TotalAfterDiscount,
         StoreID,StoreName,
         max(TransactionEntryItem.Price) as Price,
         max(TransactionEntryItem.OnHand) as OnHand,
		 SUM(RegUnitPrice*Qty) - SUM(Total) as SpecialDeficit

  FROM          
		 dbo.TransactionEntryItem  INNER JOIN #ItemSelect ON TransactionEntryItem.ItemStoreID = #ItemSelect.ItemStoreID 

    '
	Else
	set @Sel1='
SELECT   
		 '''' AS MainDepartment,
		 '''' AS SubDepartment,
         '''' AS SubSubDepartment,
		 Department,
		 [Name],
		 BarcodeNumber,
		 ModalNumber, 
		 TransactionEntryItem.ItemStoreID, 
		 ItemID, 
		 BarcodeNumber,

         SUM(QtyCase) AS QtyCase,
		 SUM(Qty) AS Qty,
	     SUM(ExtCost) as ExtCost,
		 SUM(Total) as ExtSpecialPrice,
		 SUM(RegUnitPrice*Qty) as ExtRegularPrice,

		(CASE WHEN SUM(TotalAfterDiscount)= 0 then 0
		      ELSE SUM(Profit)/ SUM(TotalAfterDiscount)
         END)
	     as MarginPrice,

         (CASE WHEN SUM(ExtCost) <> 0 then
		     SUM(Profit)/ SUM(ExtCost)
         ELSE 0
		 END) as MarkupPrice,

		 SUM(Profit) as Profit,
		
		 SUM(RegUnitPrice*Qty)-
		 (SUM(ExtCost)+SUM(Discount))
		 as RegularProfit,

         SUM(Discount) as Discount,
         SUM(TotalAfterDiscount) as TotalAfterDiscount,
         StoreID,StoreName,
         max(TransactionEntryItem.Price) as Price,
         max(TransactionEntryItem.OnHand) as OnHand,
		 SUM(RegUnitPrice*Qty) - SUM(Total) as SpecialDeficit

  FROM          
		 dbo.TransactionEntryItem   INNER JOIN #ItemSelect ON TransactionEntryItem.ItemStoreID = #ItemSelect.ItemStoreID 

    '
IF (Select COUNT(*) from SetUpValues where OptionID = 100 and ((OptionValue = '1') or(OptionValue = 'True')) And StoreID <> '00000000-0000-0000-0000-000000000000') >0
  set @Sel2= '

  GROUP BY 
  		 MainDepartment,
		 SubDepartment,
         SubSubDepartment,
		 Department,
		 TransactionEntryItem.ItemStoreID, 
		 Name, 
         BarcodeNumber, 
         ModalNumber,
 		 ItemID,
         StoreID,	
         StoreName
 '

 Else
 set @Sel2= '

  GROUP BY 
		 Department,
		 TransactionEntryItem.ItemStoreID, 
		 Name, 
         BarcodeNumber, 
         ModalNumber,
 		 ItemID,
         StoreID,	
         StoreName
 '
Print (@ItemSelect + @ItemFilter + @Sel1  + @MyWhere + @Filter + @Sel2  )
exec (@ItemSelect + @ItemFilter + @MyIndex + @CustomerSelect + @CustomerFilter + @Sel1  + @MyWhere + @Filter + @Sel2  )


drop table #ItemSelect
if @CustomerFilter<>''
drop table #CustomerSelect
GO
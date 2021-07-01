SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE procedure [dbo].[fixCost] as 

begin 
Select ItemStoreID 
				  Into #ItemSelect 
                  From ItemsRepFilter 
                  Where (1=1) 

    SELECT 	ItemStoreID,
		    Name,
			Groups,
			ParentName,
			Color,
			Size,
			ModalNumber,
		    BarcodeNumber, 
		    ItemTypeName, 
            Department,
			DepartmentID,
			'' AS MainDepartment,
			'' AS SubDepartment,
			'' AS SubSubDepartment,
			(CASE WHEN IsNull(Supplier,'')='' THEN ParentSupplerName  ELSE Supplier END)As Supplier,
			SupplierCode as ItemCodeSupplier,
			Brand,
			CustomerCode,
			SUM(Qty) AS Qty,
	       	SUM(QtyCase) AS QtyCase,
	       	SUM(ExtCost) as ExtCost,
	       	SUM(Total) as ExtPrice,
(CASE WHEN SUM(ISNULL(ExtPrice,0)) = 0 OR SUM(ISNULL(TotalAfterDiscount,0)) = 0 THEN 0 WHEN SUM(ISNULL(ExtPrice,0)) <> 0 AND SUM(ISNULL(TotalAfterDiscount,0)) <> 0  
			AND CAST((SUM(ExtPrice) - SUM(TotalAfterDiscount)) As numeric) <> 0 THEN 
			((((SUM(ExtPrice) - SUM(TotalAfterDiscount))) / SUM(ExtPrice)) ) ELSE NULL END )  AS [Discount %] ,
	   --    	(CASE WHEN SUM(TotalAfterDiscount)=0 then 0 
				--  ELSE SUM(Profit)/ 
				--	       SUM(TotalAfterDiscount)
			 --END) as MarginPrice,
			(CASE WHEN SUM(TotalAfterDiscount)=0 OR SUM(Profit)<=0 then 0
				 ELSE ((SUM(Profit))/ 
			 (SUM(TotalAfterDiscount)/100))/100
             END)
		     as MarginPrice,

	       	 (CASE 	WHEN SUM(ExtCost) <> 0 
				         THEN SUM(Profit)/
					          SUM(ExtCost)
				     ELSE 0			
			 END) as MarkupPrice,

	       	SUM(Profit) as Profit,

	        (SUM(Total) - SUM(TotalAfterDiscount))  as Discount,
               		
			SUM(TotalAfterDiscount) as TotalAfterDiscount,
			StoreName,
			StoreID,
            ItemID,
			(CASE WHEN IsNull(SupplierCode,'')='' THEN ParentCode  ELSE SupplierCode END)As ParentCode,
            max(Price) as Price,
            max(OnHand) as OnHand,
			(CASE WHEN (IsNull(SUM(Qty),0)+(max(OnHand)))>0 THEN (100 / (max(OnHand) + SUM(QTY)) * SUM(QTY))/100 ELSE 0 END) AS SellThru,
			  --STUFF ((SELECT DISTINCT ',' + ig.ItemGroupName
     --                         FROM         ItemToGroup AS itg INNER JOIN
     --                                               ItemGroup ig ON itg.ItemGroupID = ig.ItemGroupID
     --                         WHERE     itg.ItemStoreID = TransactionEntryItem.ItemStoreID AND itg.Status > 0 FOR XML PATH(''), TYPE ).value('.', 'varchar(max)'), 1, 1, '') AS Groups,
							  CustomField1,
							  CustomField2,
							  CustomField3,
							  CustomField4,
							  CustomField5,
							  CustomField6,
							  CustomField7,
							  CustomField8,
							  CustomField9,
							  CustomField10
							  into #fixmarkup
	FROM   TransactionEntryItem where (1=1) And exists (Select 1 From #ItemSelect where ItemStoreID= TransactionEntryItem.ItemStoreID) 
	
	GROUP BY    ItemStoreID,
		        Name,
				Groups,
				ParentName,
				Color,
				Size,
		        ModalNumber, 
		        BarcodeNumber,
  		        ItemTypeName, 
                Department,
				DepartmentID,
				Supplier,
		        SupplierCode,
				Brand,
				CustomerCode,
			    StoreName,
				StoreID,
				ParentCode,
                ItemID,
				ParentSupplerName,
				CustomField1,
				CustomField2,
				CustomField3,
				CustomField4,
				CustomField5,
				CustomField6,
				CustomField7,
				CustomField8,
				CustomField9,
				CustomField10

				 

	update TransactionEntry  set TransactionEntry.AVGCost=ItemMainAndStoreView.[Pc Cost], TransactionEntry.Cost =ItemMainAndStoreView.[Pc Cost]

from #fixmarkup ,ItemMainAndStoreView , TransactionEntry 
where  #fixmarkup.ItemStoreID =ItemMainAndStoreView.ItemStoreID
and TransactionEntry.ItemStoreID=#fixmarkup.ItemStoreID
--and ItemMainAndStoreView.PrefOrderBy ='Cases'
and ItemMainAndStoreView.cost !=ItemMainAndStoreView.[pc cost]
and TransactionEntry.UOMType =0 
and TransactionEntry.Cost != ItemMainAndStoreView.[pc cost]
--and    TransactionEntry.Cost -(ItemMainAndStoreView.[pc cost])  >1

				end
GO
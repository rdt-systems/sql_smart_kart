SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SP_GetDaySalesItem]
(@Day Datetime,
@ItemStoreID uniqueidentifier,
@Stores Guid_list_tbltype READONLY)

AS
IF not EXISTS ( Select 1 from @Stores) 
begin 
	 SELECT     dbo.[Transaction].StartSaleTime,
	           dbo.FormatDateTime(StartSaleTime,'HH:MM 12')As 'Time',
		    dbo.TransactionEntry.UOMQty As Qty, 
		    (dbo.TransactionEntry.Total)Price,
		    isnull( (dbo.TransactionEntry.AVGCost*dbo.TransactionEntry.UOMQty),0) Cost, 
		    dbo.Customer.CustomerNo, 
                    dbo.[Transaction].TransactionNo, 
		    dbo.[Transaction].TransactionID,
		    
		    (dbo.TransactionEntry.Total)-isnull((dbo.TransactionEntry.AVGCost*dbo.TransactionEntry.UOMQty),0) as Profit
	        
	 FROM       dbo.TransactionEntry 
	            INNER JOIN
                    dbo.[Transaction] ON dbo.TransactionEntry.TransactionID = dbo.[Transaction].TransactionID 
		    LEFT OUTER JOIN
                    dbo.Customer ON dbo.[Transaction].CustomerID = dbo.Customer.CustomerID

	 WHERE      (CONVERT(varchar, dbo.[Transaction].StartSaleTime, 110) = @Day) AND
		    (dbo.TransactionEntry.ItemStoreID = @ItemStoreID) AND 
		    (dbo.[Transaction].Status >0)AND 
		    (dbo.TransactionEntry.Status>0)
end 

else
begin 

	declare @ItemNo uniqueidentifier
	select @ItemNo =ItemNo
	from ItemStore 
	where ItemStore.ItemStoreID=@ItemStoreID

SELECT     dbo.[Transaction].StartSaleTime,
	           dbo.FormatDateTime(StartSaleTime,'HH:MM 12')As 'Time',
		    dbo.TransactionEntry.UOMQty As Qty, 
		    (dbo.TransactionEntry.Total)Price,
		    isnull( (dbo.TransactionEntry.AVGCost*dbo.TransactionEntry.UOMQty),0) Cost, 
		    dbo.Customer.CustomerNo, 
                    dbo.[Transaction].TransactionNo, 
		    dbo.[Transaction].TransactionID,
		    
		    (dbo.TransactionEntry.Total)-isnull((dbo.TransactionEntry.AVGCost*dbo.TransactionEntry.UOMQty),0) as Profit
	        ,[Store].StoreName
	 FROM       dbo.TransactionEntry 
	            INNER JOIN
                    dbo.[Transaction] ON dbo.TransactionEntry.TransactionID = dbo.[Transaction].TransactionID 
					 INNER JOIN 
            dbo.[ItemStore] on dbo.TransactionEntry.ItemStoreID=dbo.[ItemStore].ItemStoreID
			 INNER JOIN 
            dbo.[Store] on dbo.[ItemStore].Storeno=dbo.[Store].Storeid

		    LEFT OUTER JOIN
                    dbo.Customer ON dbo.[Transaction].CustomerID = dbo.Customer.CustomerID

	 WHERE      (CONVERT(varchar, dbo.[Transaction].StartSaleTime, 110) = @Day) AND
		    ([ItemStore].itemNo=@ItemNo) 
			  AND  [ItemStore].StoreNo in (select n from  @Stores)
			AND 
		    (dbo.[Transaction].Status >0)AND 
		    (dbo.TransactionEntry.Status>0)
end
GO
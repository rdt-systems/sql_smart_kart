SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE procedure [dbo].[TotalSalesSummeryWeekday]  (@Filter nvarchar(4000))  
as   
  
  
declare @MySelect nvarchar(2000)  
declare @Group nvarchar(400)  
  
  
set @MySelect= 'Select ItemStoreID   
      Into #ItemSelect   
                  From ItemsRepFilter
        
        
          
       SELECT   DATENAME (dw,StartSaleTime) as weekday,  
                     SUM(  Qty) AS Qty,   
        SUM(  ExtCost) as ExtCost,  
      SUM(  Total) as ExtPrice,   
      SUM(  TotalAfterDiscount) as TotalAfterDiscount  
    FROM TransactionEntryProfit   
    where  exists (Select 1 From #ItemSelect where ItemStoreID= TransactionEntryProfit.ItemStoreID)    
       
'  
  
  
         
set  @Group=' GROUP BY   DATENAME (dw,StartSaleTime)'  
  
  
print (@MySelect +@Filter+@Group)  
  
exec(@MySelect +@Filter+@Group+'; drop table #ItemSelect ')  
  
 
  
--[TotalSalesSummeryWeekday] @Filter=''
GO
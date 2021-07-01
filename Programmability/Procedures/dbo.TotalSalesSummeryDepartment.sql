SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE procedure [dbo].[TotalSalesSummeryDepartment]  (@Filter nvarchar(4000))  
as   
  
  
declare @MySelect nvarchar(2000)  
declare @Group nvarchar(400)  
  
  
set @MySelect= 'Select ItemStoreID   
      Into #ItemSelect   
                  From ItemsRepFilter   
                  Where (1=1)  
        
        
       SELECT   ISNULL(  MainDepartment,''[NO DEPARTMENT]'') as Department,  
                     SUM(  Qty) AS Qty,   
        SUM(  ExtCost) as ExtCost,  
      SUM(  Total) as ExtPrice,   
      SUM(  TotalAfterDiscount) as TotalAfterDiscount  
        
    FROM TransactionEntryItem   
    where  exists (Select 1 From #ItemSelect where ItemStoreID= TransactionEntryItem.ItemStoreID)   
       
'  
  
  
         
set  @Group=' GROUP BY   MainDepartment'  
  
print (@MySelect +@Filter+@Group)  
  
exec(@MySelect +@Filter+@Group+';drop table #ItemSelect  ')  
  

  
--[TotalSalesSummeryDepartment] @Filter=''
GO
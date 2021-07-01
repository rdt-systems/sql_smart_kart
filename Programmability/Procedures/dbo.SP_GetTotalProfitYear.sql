SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE procedure [dbo].[SP_GetTotalProfitYear] (@StoreId uniqueidentifier=null)    
    
as    
    
    
with a as (    
--Dashboard should load faster 
--8 Dec 2017, Raju Khadgi
select * from [dbo].[FN_GetTotalProfitYear] (@StoreId)  
    
--order by convert(varchar(10),DATEPART(yyyy, TransactionEntryItem.StartSaleTime))+RIGHT(REPLICATE('0', 2) + convert(varchar(10),DATEPART(mm, TransactionEntryItem.StartSaleTime)), 2)     
)    
select 1 as Sort, Month,MonthName,'Total Sold' as Type ,Total    
from a    
union all     

select  2 as Sort, Month, MonthName,'Total Profit' as Profit ,Profit    
from a    
union all     
select  3 as Sort, Month, MonthName,'Profit Margin' as Margin ,(Profit/ Total) AS Margin   
from a    
order by Month, Sort
GO
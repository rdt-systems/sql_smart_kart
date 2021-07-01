SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
--------------
Create   function [dbo].[ItemOnOrder](@date datetime,@StoreId nvarchar(50)) returns table
as
return
--20 Feb 2018, Raju Khadgi
select  pe.ItemNo ItemStoreId,isnull(sum(isnull([QtyOrdered],0)),0)  OnOrder  
from PurchaseOrderEntry pe  
inner join PurchaseOrders po on pe.[PurchaseOrderNo]=po.[PurchaseOrderId]
where po.Status>0 and po.PurchaseOrderDate<=@date and pe.Status>0 and (po.StoreNo=@StoreId or @StoreId is null)
group by  pe.ItemNo    

------------------------------------------------------------------
GO
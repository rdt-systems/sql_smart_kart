SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[WEB_GetCustomerOrders] 
(@CustomerID uniqueidentifier)
AS
	
SELECT    WorkOrderID,StartSaleTime,WONo,Debit,     (SELECT     SUM(Qty) AS Expr1
                            FROM         dbo.WorkOrderEntry
                            WHERE      (WorkOrderID = dbo.WorkOrder.WorkOrderID) AND (Status > 0)) AS Qty,
  
 (case when wostatus = 0 then 'Partial Order'
     	     when wostatus = -1 then  'Close'
             when wostatus=1 then 'Open' 
  when wostatus=2 then 'InProcess' end)as Status


FROM       dbo.WorkOrder
where status>0 
 and dbo.WorkOrder.CustomerID=@CustomerID

union all

SELECT    WorkOrderID,StartSaleTime,WONo,Debit,     (SELECT     SUM(Qty) AS Expr1
                            FROM        WorkOrderEntry
                            WHERE      (WorkOrderID = WorkOrder.WorkOrderID) AND (Status > 0)) AS Qty,
  
 (case when wostatus = 0 then 'Partial Order'
     	     when wostatus = -1 then  'Close'
             when wostatus=1 then 'Open' 
  when wostatus=2 then 'InProcess' end)as Status


FROM        WorkOrder
where status>0 
 and WorkOrder.CustomerID=@CustomerID
GO
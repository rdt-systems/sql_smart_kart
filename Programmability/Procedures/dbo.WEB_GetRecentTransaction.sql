SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[WEB_GetRecentTransaction]
(@ResellerID uniqueidentifier)
as

SELECT  top 10  WorkOrder.WorkOrderID,  WorkOrder.WONo, WorkOrder.Debit,convert(nvarchar,WorkOrder.StartSaleTime,101)as StartSaleTime , CustomerView.Name as CustomerName,
                        (SELECT     SUM(Qty) AS Expr1
                            FROM          WorkOrderEntry
                            WHERE      (WorkOrderID = WorkOrder.WorkOrderID) AND (Status > 0)) AS Qty
FROM         WorkOrder inner JOIN
                      CustomerView ON WorkOrder.CustomerID = CustomerView.CustomerID and CustomerView.status>0
where workorder.status>0
and workorder.resellerid=@ResellerID
order by startsaletime
GO
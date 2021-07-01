SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[SP_GetSupplierList]
(
@Filter nvarchar (50)
)
AS
BEGIN
	SELECT        Supplier.SupplierID AS SupplierNo, Supplier.Name AS SupplierName,RO.ItemStoreNo,RO.NetCost,RO.ReceiveOrderDate,RO.UOMQty 
	FROM            Supplier LEFT OUTER JOIN
								 (select * from(
	SELECT        ReceiveEntry.NetCost, ReceiveOrder.ReceiveOrderDate, ReceiveOrder.SupplierNo, ReceiveEntry.ItemStoreNo,UomQty,
	row_number() over(partition by ReceiveOrder.SupplierNo,ReceiveEntry.ItemStoreNo order by ReceiveOrder.ReceiveOrderDate desc) as rn
	FROM            ReceiveOrder INNER JOIN
							 ReceiveEntry ON ReceiveOrder.ReceiveID = ReceiveEntry.ReceiveNo where ReceiveEntry.Status>0 and ReceiveOrder.Status >0 and  (ItemStoreNo =@filter)) as t
	where rn=1) AS RO ON Supplier.SupplierID = RO.SupplierNo 
	where Supplier.Status >0
                      
     --                 SELECT Supplier.Name AS SupplierName, max(ReceiveEntry.NetCost)as NetCost, max(ReceiveEntry.UOMQty) as UOMQty, ReceiveEntry.ItemStoreNo , max(ReceiveOrder.ReceiveOrderDate)as ReceiveOrderDate , 
     --                 Supplier.SupplierID AS SupplierNo
     
     --FROM         (SELECT     *
     --                  FROM          dbo.ReceiveEntry
     --                  WHERE      (ItemStoreNo = @Filter)) AS ReceiveEntry INNER JOIN
     --                 dbo.ReceiveOrder ON ReceiveEntry.ReceiveNo = dbo.ReceiveOrder.ReceiveID RIGHT OUTER JOIN
     --                 dbo.Supplier ON dbo.ReceiveOrder.SupplierNo = dbo.Supplier.SupplierID
                      
        
                      
                      
     --                 WHERE    (ISNULL(dbo.ReceiveOrder.Status, 1) > - 1)  AND (Supplier.Status > - 1) AND  (ISNULL(ReceiveEntry.Status, 1) > - 1)
                      
                     
     --                     group by Supplier.Name  ,  ReceiveEntry.ItemStoreNo ,  Supplier.SupplierID 

END
GO
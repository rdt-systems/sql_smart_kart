SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[Sp_rptRecicveValue]
(@Filter nvarchar(4000))
AS

DECLARE @MySelect nvarchar(4000)
DECLARE @MyGroup nvarchar(4000)

IF (SELECT COUNT(1) FROM DepartmentStore Where ParentDepartmentID IN (SELECT DepartmentStoreID From DepartmentStore Where Status >0) And Status >0) >0
SET @MySelect ='SELECT     ItemMainAndStoreView.MainDepartment, ItemMainAndStoreView.SubDepartment, ItemMainAndStoreView.SubSubDepartment,   ItemMainAndStoreView.Department, SUM(ReceiveEntry.Qty) AS Qty, SUM(ReceiveEntry.ExtPrice) AS Cost,
SUM(ReceiveEntry.Qty * ItemsForSale.RealPrice) AS Price,
                         ItemMainAndStoreView.StoreName
FROM            
                         ReceiveOrder   INNER JOIN
                         ItemMainAndStoreView INNER JOIN
                         ReceiveEntry ON ItemMainAndStoreView.ItemStoreID = ReceiveEntry.ItemStoreNo ON ReceiveOrder.ReceiveID = ReceiveEntry.ReceiveNo INNER JOIN
                         ItemsForSale ON ItemMainAndStoreView.ItemStoreID = ItemsForSale.ItemStoreID
						 WHERE ReceiveEntry.Status>0'

ELSE
SET @MySelect ='SELECT    '''' AS MainDepartment, '''' AS SubDepartment, '''' AS SubSubDepartment,   ItemMainAndStoreView.Department, SUM(ReceiveEntry.Qty) AS Qty, SUM(ReceiveEntry.ExtPrice) AS Cost, SUM(ReceiveEntry.Qty * ItemsForSale.RealPrice) AS Price,

                         ItemMainAndStoreView.StoreName
FROM           
                         ReceiveOrder   INNER JOIN
                         ItemMainAndStoreView INNER JOIN
                         ReceiveEntry ON ItemMainAndStoreView.ItemStoreID = ReceiveEntry.ItemStoreNo ON ReceiveOrder.ReceiveID = ReceiveEntry.ReceiveNo INNER JOIN
                         ItemsForSale ON ItemMainAndStoreView.ItemStoreID = ItemsForSale.ItemStoreID
						 WHERE ReceiveEntry.Status>0'
IF (SELECT COUNT(1) FROM DepartmentStore Where ParentDepartmentID IN (SELECT DepartmentStoreID From DepartmentStore Where Status >0) And Status >0) >0
SET @MyGroup ='GROUP BY ItemMainAndStoreView.MainDepartment, ItemMainAndStoreView.SubDepartment, ItemMainAndStoreView.SubSubDepartment, ItemMainAndStoreView.Department, ItemMainAndStoreView.StoreName'
ELSE
SET @MyGroup ='GROUP BY ItemMainAndStoreView.Department, ItemMainAndStoreView.StoreName'


print (@MySelect + @Filter+@MyGroup )
Execute (@MySelect + @Filter+@MyGroup )
GO
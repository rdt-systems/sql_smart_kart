SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO



CREATE PROCEDURE [dbo].[Sp_PO_Receive_Report]
(@Filter nvarchar(4000),
@Filter2 nvarchar(4000)='')
AS

DECLARE @MySelect nvarchar(4000)
DECLARE @MyGroup nvarchar(4000)
DECLARE @MyGroup2 nvarchar(4000)
SET @MySelect ='
SELECT  IMS.StoreName, IMS.BarcodeNumber, IMS.ModalNumber, IMS.Name, Manufacturers.ManufacturerName, DepartmentStore.Name AS Department, 
ISNULL(IMS.OnHand, 0) AS OnHand, 
  ReceiveEntry.SupplierName AS Supplier, 
 IMS.Cost,
 IMS.Price,
   CAST(SUM(ISNULL(ReceiveEntry.UOMQty, 0)) AS decimal(18,2)) AS QtyReceived, 
  CAST(SUM(ISNULL(IMS.Cost, 0)) * SUM(ISNULL(ReceiveEntry.UOMQty, 0)) AS money)   AS ReceivedValue,
  CAST(SUM(ISNULL(IMS.Price, 0)) * SUM(ISNULL(ReceiveEntry.UOMQty, 0)) AS money) AS ReceivedSellingPrice,
   
    IMS.MainDepartment, IMS.SubDepartment, IMS.SubSubDepartment, 
  IMS.CustomField1, IMS.CustomField2, IMS.CustomField3, IMS.CustomField4, IMS.CustomField5, IMS.CustomField6, IMS.CustomField7, IMS.CustomField8, IMS.CustomField9, IMS.CustomField10
FROM  ItemMainAndStoreView AS IMS LEFT OUTER JOIN
  Manufacturers ON Manufacturers.ManufacturerID = IMS.ManufacturerID  LEFT OUTER JOIN
  DepartmentStore ON DepartmentStore.DepartmentStoreID = IMS.DepartmentID INNER JOIN
  (SELECT  ReceiveEntry.ItemStoreNo, Supplier.Name AS SupplierName, SUM(ReceiveEntry.UOMQty) AS UOMQty
  FROM  ReceiveEntry AS ReceiveEntry INNER JOIN
  ReceiveOrder ON ReceiveEntry.ReceiveNo = ReceiveOrder.ReceiveID INNER JOIN
  Supplier ON Supplier.SupplierID = ReceiveOrder.SupplierNo INNER JOIN
  Bill ON ReceiveOrder.BillID = Bill.BillID
  WHERE  (ReceiveOrder.Status > 0) AND (ReceiveEntry.Status > 0)
 '

  set @MyGroup =' 
  GROUP BY ReceiveEntry.ItemStoreNo, Supplier.Name) AS ReceiveEntry ON ReceiveEntry.ItemStoreNo = IMS.ItemStoreID AND IMS.MainStatus > 0 AND IMS.Status > 0 where 1=1  '

    set @MyGroup2 =' 
GROUP BY IMS.StoreName, IMS.BarcodeNumber, IMS.ModalNumber, IMS.Name, Manufacturers.ManufacturerName, DepartmentStore.Name, ISNULL(IMS.OnHand, 0), ReceiveEntry.SupplierName, IMS.MainDepartment, 
  IMS.SubDepartment, IMS.SubSubDepartment, IMS.CustomField1, IMS.CustomField2, IMS.CustomField3, IMS.CustomField4, IMS.CustomField5, IMS.CustomField6, IMS.CustomField7, IMS.CustomField8, 
  IMS.CustomField9, IMS.CustomField10, IMS.Cost, IMS.Price
'

print (@MySelect + @Filter+@MyGroup+@Filter2+@MyGroup2)
Execute (@MySelect + @Filter+@MyGroup+@Filter2+@MyGroup2 )
GO
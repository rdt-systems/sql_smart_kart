SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[Rpt_ItemDetailsOnPhoneOrder] 
(@Filter NVARCHAR(4000))

AS

DECLARE @MySelect NVARCHAR(4000)

IF EXISTS(SELECT * FROM Store WHere StoreID = 'E1E5574B-26DD-4E4C-BDF0-23632AE304B1')
SET @MySelect = 'SELECT        PhoneOrderEntry.Qty, ItemMain.Name, ItemMain.ModalNumber, ItemMain.BarcodeNumber, ItemStore.Cost, ItemStore.Price, ItemStore.OnHand, ItemStore.ItemStoreID, PhoneOrderEntry.Note, 
                         PhoneOrder.PhoneOrderNo, CustomerView.CustomerNo, CustomerView.FirstName, CustomerView.LastName, GG.ItemGroupName AS Groups ,PhoneOrder.PickNote,PhoneOrderType.SystemValueName AS PhoneOrderType ,PhoneOrder.DeliveryDate,PhoneOrderEntry.DateCreated
FROM            CustomerView INNER JOIN
                         ItemMain INNER JOIN
                         ItemStore ON ItemMain.ItemID = ItemStore.ItemNo INNER JOIN
                         PhoneOrderEntry ON PhoneOrderEntry.ItemStoreNo = ItemStore.ItemStoreID INNER JOIN
                         PhoneOrder ON PhoneOrderEntry.PhoneOrderID = PhoneOrder.PhoneOrderID ON CustomerView.CustomerID = PhoneOrder.CustomerID LEFT OUTER JOIN
                             (SELECT DISTINCT G.ItemGroupName, GC.ItemStoreID
                               FROM            ItemGroup AS G INNER JOIN
                                                         ItemToGroup AS GC ON G.ItemGroupID = GC.ItemGroupID
                               WHERE        (G.Status > 0) AND (GC.Status > 0)) AS GG ON ItemStore.ItemStoreID = GG.ItemStoreID
							   		   LEFT OUTER JOIN  (SELECT        SystemValueName, SystemValueNo
                               FROM            SystemValues
                               WHERE        (SystemTableNo = 56)) AS PhoneOrderType ON PhoneOrder.Type = PhoneOrderType.SystemValueNo
WHERE        (PhoneOrderEntry.Status > 0) AND (PhoneOrder.Status > 0) AND (PhoneOrder.PhoneOrderStatus <> 1) '

ELSE

SET @MySelect= 'SELECT     dbo.PhoneOrderEntry.Qty, dbo.ItemMainAndStoreView.Name, dbo.ItemMainAndStoreView.ModalNumber, 
                      dbo.ItemMainAndStoreView.BarcodeNumber, dbo.ItemMainAndStoreView.Cost, dbo.ItemMainAndStoreView.Price, dbo.ItemMainAndStoreView.OnHand, 
                      dbo.ItemMainAndStoreView.ItemStoreID,
					  PhoneOrderEntry.Note,
					  PhoneOrder.PhoneOrderNo,
					  CustomerView.CustomerNo,
					  CustomerView.FirstName,
					    CustomerView.LastName,
						dbo.ItemMainAndStoreView.Groups,
						PhoneOrder.PickNote,
						PhoneOrderType.SystemValueName AS PhoneOrderType  ,PhoneOrder.DeliveryDate,PhoneOrderEntry.DateCreated
FROM         dbo.ItemMainAndStoreView INNER JOIN
                      dbo.PhoneOrderEntry ON dbo.PhoneOrderEntry.ItemStoreNo = dbo.ItemMainAndStoreView.ItemStoreID INNER JOIN
                      dbo.PhoneOrder ON dbo.PhoneOrderEntry.PhoneOrderID = dbo.PhoneOrder.PhoneOrderID INNER JOIN
					  dbo.CustomerView on dbo.CustomerView.CustomerID=PhoneOrder.CustomerID
					  		   LEFT OUTER JOIN  (SELECT        SystemValueName, SystemValueNo
                               FROM            SystemValues
                               WHERE        (SystemTableNo = 56)) AS PhoneOrderType ON PhoneOrder.Type = PhoneOrderType.SystemValueNo
WHERE     (dbo.PhoneOrderEntry.Status > 0) AND (dbo.PhoneOrder.Status > 0) AND (dbo.PhoneOrder.PhoneOrderStatus <> 1)  '




print (@MySelect + @Filter )
Execute (@MySelect + @Filter )
GO
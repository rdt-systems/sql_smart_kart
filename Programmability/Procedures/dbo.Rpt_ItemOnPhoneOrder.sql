SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[Rpt_ItemOnPhoneOrder] 
(@Filter NVARCHAR(4000))

AS

DECLARE @MySelect NVARCHAR(4000)
SET @MySelect= 'SELECT     SUM(dbo.PhoneOrderEntry.Qty) AS Qty, dbo.ItemMainAndStoreView.Name, dbo.ItemMainAndStoreView.ModalNumber, 
                      dbo.ItemMainAndStoreView.BarcodeNumber, dbo.ItemMainAndStoreView.Cost, dbo.ItemMainAndStoreView.Price, dbo.ItemMainAndStoreView.OnHand, 
                      dbo.ItemMainAndStoreView.ItemStoreID ,PhoneOrderType.SystemValueName AS PhoneOrderType
FROM         dbo.ItemMainAndStoreView INNER JOIN
                      dbo.PhoneOrderEntry ON dbo.PhoneOrderEntry.ItemStoreNo = dbo.ItemMainAndStoreView.ItemStoreID INNER JOIN
                      dbo.PhoneOrder ON dbo.PhoneOrderEntry.PhoneOrderID = dbo.PhoneOrder.PhoneOrderID
					   LEFT OUTER JOIN  (SELECT        SystemValueName, SystemValueNo
                               FROM            SystemValues
                               WHERE        (SystemTableNo = 56)) AS PhoneOrderType ON PhoneOrder.Type = PhoneOrderType.SystemValueNo
WHERE     (dbo.PhoneOrderEntry.Status > 0) AND (dbo.PhoneOrder.Status > 0) AND (dbo.PhoneOrder.PhoneOrderStatus <> 1) '
DECLARE @GroupBy NVARCHAR(4000)
SET @GroupBy='GROUP BY dbo.ItemMainAndStoreView.Name, dbo.ItemMainAndStoreView.ModalNumber, 
                      dbo.ItemMainAndStoreView.BarcodeNumber, dbo.ItemMainAndStoreView.Cost, dbo.ItemMainAndStoreView.Price, dbo.ItemMainAndStoreView.OnHand 
		,dbo.ItemMainAndStoreView.ItemStoreID,PhoneOrderType.SystemValueName'

print (@MySelect + @Filter+@GroupBy )
Execute (@MySelect + @Filter+@GroupBy )
GO
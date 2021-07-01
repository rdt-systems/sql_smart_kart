SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE VIEW [dbo].[SalesIncentiveView]
AS
SELECT        dbo.SalesIncentive.SalesIncentiveID, dbo.SalesIncentive.ItemMainID, dbo.SalesIncentive.IncentiveValueAmount, dbo.SalesIncentive.Status, 
                         dbo.ItemMainAndStoreView.Name, dbo.ItemMainAndStoreView.Department, dbo.ItemMainAndStoreView.Brand, dbo.ItemMainAndStoreView.BarcodeNumber, 
                         dbo.ItemMainAndStoreView.ModalNumber, dbo.ItemMainAndStoreView.StoreNo, dbo.ItemMainAndStoreView.ItemStoreID, dbo.ItemMainAndStoreView.DepartmentID, 
                         dbo.ItemMainAndStoreView.[Pc Cost], dbo.ItemMainAndStoreView.Price, dbo.ItemMainAndStoreView.Markup, dbo.ItemMainAndStoreView.Margin, 
                         dbo.ItemMainAndStoreView.ItemID, dbo.SalesIncentive.DateModified, dbo.SalesIncentive.SalesIncentiveHeaderID
FROM            dbo.SalesIncentive RIGHT OUTER JOIN
                         dbo.ItemMainAndStoreView ON dbo.SalesIncentive.ItemMainID = dbo.ItemMainAndStoreView.ItemID
WHERE        (dbo.ItemMainAndStoreView.Status > 0)
GO
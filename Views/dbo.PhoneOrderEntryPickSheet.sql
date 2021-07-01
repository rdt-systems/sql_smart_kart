SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE VIEW [dbo].[PhoneOrderEntryPickSheet]
AS
SELECT        TOP (100) PERCENT ItemMainAndStoreView.BarcodeNumber, PhoneOrderEntryView.UOMPrice, ItemMainAndStoreView.Name, ItemMainAndStoreView.ModalNumber, PhoneOrderEntryView.Qty, PhoneOrderEntryView.Note, 
                         CAST(0 AS bit) AS Picked, PhoneOrderEntryView.PhoneOrderID, PhoneOrderEntryView.SortOrder, PhoneOrderEntryView.Status, 
                         (CASE WHEN PhoneOrderEntryView.UOMType = 0 THEN 'Pc' WHEN PhoneOrderEntryView.UOMType = 1 THEN 'Dz' WHEN PhoneOrderEntryView.UOMType = 2 THEN 'Cs' END) 
						 COLLATE SQL_Latin1_General_CP1_CI_AS AS UomType, ItemMainAndStoreView.ManufacturerPartNo, ItemMainAndStoreView.Department, ItemMainAndStoreView.OnHand, ItemMainAndStoreView.Groups AS ItemGroups, 
                         ItemMainAndStoreView.Brand
FROM            PhoneOrderEntryView LEFT OUTER JOIN
                         ItemMainAndStoreView ON ItemMainAndStoreView.ItemStoreID = PhoneOrderEntryView.ItemStoreNo
WHERE        (PhoneOrderEntryView.Status > 0)
ORDER BY PhoneOrderEntryView.SortOrder
GO
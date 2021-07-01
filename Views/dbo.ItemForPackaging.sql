SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO






CREATE VIEW [dbo].[ItemForPackaging]
AS
SELECT        ItemStore.Price, ItemMain.Name, ItemMain.Description, CONVERT(nvarchar(4000), ItemMain.ExtraInfo) AS ExtraInfo, ItemMain.BarcodeNumber, ISNULL(ItemMain.Units, 0) AS Units, ItemMain.ItemPicture, 
                         CONVERT(nvarchar(4000), ItemMain.ExtraInfo2) AS ExtraInfo2, ItemMain.Size, ItemStore.Tare, (CASE WHEN (ItemStore.SaleType IN (1, 5, 12)) THEN CASE WHEN ISNULL(ItemStore.AssignDate, 0) 
                         > 0 THEN CASE WHEN (dbo.GetDay(ItemStore.SaleEndDate) >= dbo.GetDay(dbo.GetLocalDATE())) THEN ItemStore.SalePrice ELSE NULL END ELSE ItemStore.SalePrice END ELSE NULL END) AS SpecialPrice, 
                         CASE WHEN ISNULL(dbo.ItemMain.CustomInteger1, 0) <> 0 THEN dbo.GetDay(dbo.GetLocalDate() + dbo.ItemMain.CustomInteger1) ELSE dbo.GetDay(dbo.GetLocalDate()) END AS ExpireDate
FROM            ItemMain INNER JOIN
                         ItemStore ON ItemMain.ItemID = ItemStore.ItemNo
WHERE        (ItemMain.Status > 0) AND (ItemStore.Status > 0)
GO
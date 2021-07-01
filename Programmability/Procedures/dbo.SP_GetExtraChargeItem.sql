SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SP_GetExtraChargeItem]

 as
--select * from dbo.ExtraChargeItem

SELECT     Name, BarcodeNumber, ItemStoreID, Price
FROM         ItemMainAndStoreView
WHERE     1=1 AND (ItemType = 5) AND (Status > 0)
GO
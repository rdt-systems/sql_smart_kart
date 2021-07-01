SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE VIEW [dbo].[DiscountItemPOS]
AS
SELECT        ItemDiscountID, DiscountID, DateModified, ItemID, Status
FROM            dbo.DiscountItem
WHERE        (Status > 0)
GO
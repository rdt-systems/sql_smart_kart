SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE VIEW [dbo].[DiscountStorePOS]
AS
SELECT        DiscountID, StoreID, DateModified, DiscountStoreID, Status
FROM            dbo.DiscountStore
WHERE        (Status > 0)
GO
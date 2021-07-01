SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE VIEW [dbo].[DiscountBrandPOS]
AS
SELECT        DiscountID, DiscountBrandID, DateModified, BrandID, Status
FROM            dbo.DiscountBrand
WHERE        (Status > 0)
GO
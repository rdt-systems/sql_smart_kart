SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SP_DiscountBrandPOS]
(
@DateModified datetime=null
)
AS 
SELECT        DiscountID, DiscountBrandID, DateModified, BrandID, Status
FROM            dbo.DiscountBrand
WHERE        (Status > 0) AND (DateModified >@DateModified)
GO
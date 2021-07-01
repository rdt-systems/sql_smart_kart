SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SP_DiscountBrandDelete]
(@DiscountBrandID uniqueidentifier,
@ModifierID uniqueidentifier)
AS
 DELETE FROM DiscountBrand WHERE [DiscountBrandID] = @DiscountBrandID
GO
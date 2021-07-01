SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SP_DiscountItemPOS]
(
@DateModified datetime=null
)
AS 
SELECT       ItemDiscountID, DiscountID, DateModified, ItemID, Status
FROM            dbo.DiscountItem
WHERE        (Status > 0) AND (DateModified >@DateModified)
GO
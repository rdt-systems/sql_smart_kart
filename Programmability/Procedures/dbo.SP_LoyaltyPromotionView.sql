SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SP_LoyaltyPromotionView]
(
@DateModified datetime=null
)
AS 
SELECT [LoyaltyPromotionView].*  FROM [LoyaltyPromotionView]  WHERE (DateModified >@DateModified) AND Status>0
GO
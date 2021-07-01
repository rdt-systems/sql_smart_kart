SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SP_DiscountStoreDelete]
(@DiscountStoreID uniqueidentifier
,@ModifierID uniqueidentifier)
AS
 DELETE FROM DiscountStore WHERE [DiscountStoreID] = @DiscountStoreID
GO
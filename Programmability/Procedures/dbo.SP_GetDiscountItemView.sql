SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SP_GetDiscountItemView]
(@DiscountID uniqueidentifier = NULL)
AS
  SELECT * FROM DiscountItemView  Where  (DiscountID = @DiscountID OR @DiscountID IS NULL)
GO
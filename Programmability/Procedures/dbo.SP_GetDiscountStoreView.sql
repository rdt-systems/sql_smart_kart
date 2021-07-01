SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SP_GetDiscountStoreView]
(
@DiscountID uniqueidentifier = NULL
)
AS

  SELECT * FROM DiscountStoreView Where (DiscountID = @DiscountID OR @DiscountID IS NULL) and Status > -1
GO
SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


Create PROCEDURE [dbo].[SP_GetDiscountToLink]
(@DiscountID uniqueidentifier)
AS
SELECT * FROM DiscountToLink WHERE DiscountID = @DiscountID AND Status>0
GO
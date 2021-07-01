SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SP_GetDiscountFromLink]
(@DiscountID uniqueidentifier)
AS
SELECT * FROM DiscountFromLink WHERE DiscountID = @DiscountID AND Status>0
GO
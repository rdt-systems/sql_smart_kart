SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SP_GetDiscountGroup]
(@DiscountGroupID uniqueidentifier = NULL)
AS
SELECT * FROM DiscountGroup WHERE DiscountGroupID = @DiscountGroupID AND Status>0
GO
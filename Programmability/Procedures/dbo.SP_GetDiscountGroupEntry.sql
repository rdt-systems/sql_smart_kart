SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


Create PROCEDURE [dbo].[SP_GetDiscountGroupEntry]
(@DiscountGroupID uniqueidentifier)
AS
SELECT * FROM DiscountGroupEntry WHERE DiscountGroupID = @DiscountGroupID AND Status>0
GO
SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SP_GetDiscountGroupEntryView]
(@DiscountGroupEntryID uniqueidentifier)
AS
SELECT * FROM DiscountGroupEntry WHERE DiscountGroupEntryID = @DiscountGroupEntryID AND Status>0
GO
SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SP_TenderToDiscountDelete]
(@TenderToDiscountID uniqueidentifier,
@ModifierID uniqueidentifier)
AS UPDATE    dbo.TenderToDiscount
SET              Status = -1, DateModified = dbo.GetLocalDATE()
WHERE  TenderToDiscountID = @TenderToDiscountID
GO
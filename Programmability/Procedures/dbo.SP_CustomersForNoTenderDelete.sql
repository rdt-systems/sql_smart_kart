SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SP_CustomersForNoTenderDelete]
(@CustomersForNoTenderId uniqueidentifier,
@ModifierID uniqueidentifier)
AS UPDATE    dbo.CustomersForNoTender
SET              Status = -1, DateModified = dbo.GetLocalDATE()
WHERE  CustomersForNoTenderId = @CustomersForNoTenderId
GO
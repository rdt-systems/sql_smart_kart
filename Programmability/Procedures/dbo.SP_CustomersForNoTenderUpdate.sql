SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SP_CustomersForNoTenderUpdate]
(@CustomersForNoTenderID uniqueidentifier,
@CustomerId uniqueidentifier,
@TenderID int,
@Status smallint,
@DateModified datetime,
@ModifierID uniqueidentifier)

AS 

UPDATE dbo.CustomersforNoTender

SET 
customerid = @customerid,
TenderID= @TenderID,
Status=@Status,
DateModified=dbo.GetLocalDATE(),
UserModified= @ModifierID

WHERE customersfornotenderid= @CustomersForNoTenderID
GO
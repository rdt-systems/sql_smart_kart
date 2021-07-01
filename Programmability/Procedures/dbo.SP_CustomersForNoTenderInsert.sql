SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SP_CustomersForNoTenderInsert]
(@CustomersForNoTenderID uniqueidentifier,
@CustomerId uniqueidentifier,
@TenderID int,
@ModifierID uniqueidentifier,
@Status smallint)
AS INSERT INTO dbo.CustomersForNoTender
                      (CustomersForNoTenderID, CustomerId,TenderID, Status, DateCreated, UserCreated, DateModified, UserModified)
VALUES     (@CustomersForNoTenderID, @Customerid,@TenderID, @Status, dbo.GetLocalDATE(), @ModifierID, dbo.GetLocalDATE(), @ModifierID)
GO
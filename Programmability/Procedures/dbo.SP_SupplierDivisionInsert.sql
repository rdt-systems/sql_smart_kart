SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SP_SupplierDivisionInsert]
(@TransactionID uniqueidentifier,
@ApplyAmount money,
@Status smallint,
@ModifierID uniqueidentifier
)
AS INSERT INTO dbo.SupplierDivision
                      (TransactionID, ApplyAmount, Status, DateCreated, UserCreated, 
                      DateModified, UserModified)
VALUES     (@TransactionID, @ApplyAmount,1, dbo.GetLocalDATE(), 
                      @ModifierID, dbo.GetLocalDATE(), @ModifierID)
GO
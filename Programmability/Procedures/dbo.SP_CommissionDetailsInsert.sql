SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SP_CommissionDetailsInsert]
(@CommissionDetailsID uniqueidentifier,
@CommissionID uniqueidentifier,
@TransactionID uniqueidentifier,
@Amount  money,
@Commission money,
@Status smallint,
@ModifierID uniqueidentifier)

AS INSERT INTO dbo.CommissionDetails
                      (CommissionDetailsID, CommissionID, TransactionID, Amount, Commission, Status, DateCreated, UserCreated, DateModified, UserModified)

VALUES     (@CommissionDetailsID, @CommissionID, @TransactionID, round(@Amount,2), round(@Commission,2), 1, dbo.GetLocalDATE(), @ModifierID, dbo.GetLocalDATE(), @ModifierID)
GO
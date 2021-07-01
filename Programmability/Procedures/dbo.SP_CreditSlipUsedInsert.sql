SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SP_CreditSlipUsedInsert]
(@CreditSlipUsedID uniqueidentifier,
@CreditSlipID char(50),
@TransactionID uniqueidentifier,
@Amount money,
@Status smallint,
@ModifierID uniqueidentifier)

AS INSERT INTO dbo.CreditSlipUsed
                      (CreditSlipUsedID, CreditSlipID,   TransactionID,   Amount,  Status,   DateCreated, UserCreated, DateModified, UserModified)

VALUES     (@CreditSlipUsedID, @CreditSlipID, @TransactionID, @Amount, 1,          dbo.GetLocalDATE(), @ModifierID,  dbo.GetLocalDATE(),  @ModifierID)
GO
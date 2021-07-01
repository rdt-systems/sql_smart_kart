SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SP_DeleteCashCheck](
	@CashCheckID uniqueidentifier,
	@ModifierID uniqueidentifier = NULL)

AS

BEGIN

Update CashCheck Set Status = -1, DateModified = dbo.GetLocalDATE(), UserModified = @ModifierID Where CashCheckID = @CashCheckID

Update TenderEntry Set Status = -1, DateModified = dbo.GetLocalDATE(), UserModified = @ModifierID Where TransactionID = @CashCheckID



END
GO
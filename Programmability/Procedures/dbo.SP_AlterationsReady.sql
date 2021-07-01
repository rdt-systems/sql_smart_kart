SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


-- =============================================
-- Author:		Moshe Freund
-- ALTER date: 10/27/2015
-- Description:	[SP_AlterationsReady]
-- =============================================
CREATE PROCEDURE [dbo].[SP_AlterationsReady]
	@ID int,
	@StoreID uniqueidentifier
AS
IF (Select COUNT(*) from Alterations Where AlterationID = @ID AND ConveyorID IS NULL) >0

BEGIN

Declare @TransactionID uniqueidentifier
Declare @NoOfSlots int 
Set @TransactionID = (SELECT TOP(1) TransactionID from Alterations Where AlterationID = @ID)
Set @NoOfSlots = (Select COUNT(*) from Alterations Where TransactionID = @TransactionID And ConveyorID IS NULL)


EXEC sp_GetAvailableConniverSlot
@Slots = @NoOfSlots,
@StoreID = @StoreID




END

ELSE 
BEgin
Update Alterations Set AlterationStatus = 3, DateModified = dbo.GetLocalDATE() Where AlterationID = @ID
end
GO
SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SP_BatchInsert]

(@BatchID uniqueidentifier,
@BatchNumber nvarchar(50), 
@CashierID uniqueidentifier, 
@StoreID uniqueidentifier, 
@BatchStatus int, 
@RegisterID uniqueidentifier,
@OpeningDateTime datetime, 
@ClosingDateTime datetime, 
@OpeningAmount money,
@ClosingAmount money,
@OpenHunderdBills Int,
@OpenFiftyBills Int,
@OpenTwentyBills Int, 
@OpenTenBills Int, 
@OpenFiveBills Int,
@OpenSingels Int, 
@OpenQuarter Int,
@OpenDimes Int,
@OpenNickels Int, 
@OpenPennies Int,
@OpenOther decimal, 
@CloseHunderdBills Int,  
@CloseFiftyBills Int,  
@CloseTwentyBills Int,  
@CloseTenBills Int,  
@CloseFiveBills Int,  
@CloseSingels Int,  
@CloseQuarter Int,  
@CloseDimes Int,  
@CloseNickels Int,  
@ClosePennies Int,  
@CloseOther decimal,
@Status smallint,
@ModifierID uniqueidentifier)

AS

INSERT INTO dbo.batch
       (BatchID,BatchNumber,CashierID,StoreID,BatchStatus,RegisterID,OpeningDateTime,ClosingDateTime,
	OpeningAmount,ClosingAmount,OpenHunderdBills,OpenFiftyBills,OpenTwentyBills,  
	OpenTenBills,OpenFiveBills,OpenSingels,OpenQuarter,OpenDimes,OpenNickels,OpenPennies,  
	OpenOther,CloseHunderdBills,CloseFiftyBills,CloseTwentyBills,CloseTenBills,CloseFiveBills,
	CloseSingels,CloseQuarter,CloseDimes,CloseNickels,ClosePennies,CloseOther,
	Status,DateCreated,UserCreated,DateModified,UserModified)
VALUES  (@BatchID,@BatchNumber,@CashierID,@StoreID,@BatchStatus,@RegisterID,@OpeningDateTime,@ClosingDateTime,
	@OpeningAmount,@ClosingAmount,@OpenHunderdBills,@OpenFiftyBills,@OpenTwentyBills,  
	@OpenTenBills,@OpenFiveBills,@OpenSingels,@OpenQuarter,@OpenDimes,@OpenNickels,@OpenPennies,  
	@OpenOther,@CloseHunderdBills,@CloseFiftyBills,@CloseTwentyBills,@CloseTenBills,@CloseFiveBills,
	@CloseSingels,@CloseQuarter,@CloseDimes,@CloseNickels,@ClosePennies,@CloseOther,
	1,dbo.GetLocalDATE(),@ModifierID,dbo.GetLocalDATE(),@ModifierID)
GO
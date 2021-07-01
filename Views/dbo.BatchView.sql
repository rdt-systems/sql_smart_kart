SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO

CREATE VIEW [dbo].[BatchView]
AS



SELECT BatchID,
       BatchNumber,
       CashierID,
       StoreID,
       BatchStatus,
       RegisterID,
       OpeningDateTime,
       ClosingDateTime,
       OpeningAmount,
       ClosingAmount,
       OpenHunderdBills,
       OpenFiftyBills,
       OpenTwentyBills,
       OpenTenBills,
       OpenFiveBills,
       OpenSingels,
       OpenQuarter,
       OpenDimes,
       OpenNickels,
       OpenPennies,
       OpenOther,
       CloseHunderdBills,
       CloseFiftyBills,
       CloseTwentyBills,
       CloseTenBills,
       CloseFiveBills,
       CloseSingels,
       CloseQuarter,
       CloseDimes,
       CloseNickels,
       ClosePennies,
       CloseOther,
       Status,
       DateCreated,
       UserCreated,
       DateModified,
       UserModified,
       BatchText 
	   FROM dbo.Batch
GO
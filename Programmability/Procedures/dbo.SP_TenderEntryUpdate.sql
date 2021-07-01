SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SP_TenderEntryUpdate]
(@TenderEntryId uniqueidentifier,
@TenderID int,
@TransactionID uniqueidentifier,
@Amount money,
@Common1 nvarchar(50),
@Common2 nvarchar(50),
@Common3 nvarchar(50),
@Common4 nvarchar(50),
@Common5 nvarchar(50),
@Common6 nvarchar(50),
@TenderDate datetime,
@Status smallint,
@DateModified datetime,
@ModifierID uniqueidentifier,
@TransactionType int = 0)
As

Declare @UpdateTime datetime
set  @UpdateTime =dbo.GetLocalDATE()

UPDATE  dbo.TenderEntry
Set     TenderID =  @TenderID, 
	TransactionID = @TransactionID, 
	Amount = @Amount,
	Common1 = @Common1, 
	Common2 = @Common2, 
	Common3 = @Common3, 
	Common4 = @Common4, 
	Common5 = @Common5, 
	Common6 = @Common6, 
	TenderDate=@TenderDate,
	Status = @Status,  
        DateModified = @UpdateTime,  
	UserModified = @ModifierID,
	TransactionType = @TransactionType

WHERE   (TenderEntryId = @TenderEntryId) and  (DateModified = @DateModified or DateModified is NULL)

UPDATE  dbo.W_TenderEntry
Set     TenderID =  @TenderID, 
	TransactionID = @TransactionID, 
	Amount = @Amount,
	Common1 = @Common1, 
	Common2 = @Common2, 
	Common3 = @Common3, 
	Common4 = @Common4, 
	Common5 = @Common5, 
	Common6 = @Common6, 
	TenderDate=@TenderDate,
	Status = @Status,  
        DateModified = @UpdateTime,  
	UserModified = @ModifierID,
	TransactionType = @TransactionType

WHERE   (TenderEntryId = @TenderEntryId) and  (DateModified = @DateModified or DateModified is NULL)


select @UpdateTime as DateModified
GO
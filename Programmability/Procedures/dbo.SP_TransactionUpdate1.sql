SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO

CREATE PROCEDURE [dbo].[SP_TransactionUpdate1]
(@TransactionID uniqueidentifier,
@CustomerID uniqueidentifier,
@Debit money,
@Credit money,
@Tax money,
@TaxID uniqueidentifier,
@TaxType nvarchar(50),
@TaxRate decimal(19,3),
@ShipTo uniqueidentifier,
@Note nvarchar(4000),
@RecieptTxt ntext,
@ChangeLogs Nvarchar(2000),
@Status int,
@ModifierID uniqueidentifier)


AS 


SET XACT_ABORT ON;
BEGIN TRANSACTION

--if ((select Count(*) from [transaction] where TransactionNo=@TransactionNo and Status>-1)> 0) 
--begin
--	 RAISERROR  ('Transaction No Alredy Exists.',20,1)  --WITH LOG

--end
declare @OlDCustomerID uniqueidentifier
declare @OldCredit money
declare @OldDebit money
Declare @OldRecieptTxt Nvarchar(4000)

SELECT TOP(1)@OlDCustomerID =CustomerID,@OldCredit =Credit,@OldDebit = debit,@OldRecieptTxt=reciepttxt  from [Transaction] Where TransactionID = @TransactionID 


INSERT INTO [dbo].[TransactionLogs]
           ([TransactionID]
           ,[OldCustomerID]
           ,[OldRecipt]
           ,[ChangeLogs]
           ,[Status]
           ,[DateCreated]
           ,[UserCreated])
     VALUES
           (@TransactionID,
            @OlDCustomerID,
            @OldRecieptTxt,
            @ChangeLogs,
            1,
            dbo.GetLocalDATE(),
            @ModifierID)

IF @OldCustomerID is not null AND @Status>0 
BEGIN
  UPDATE Customer Set BalanceDoe = BalanceDoe-(@OldDebit-@OldCredit) WHERE CustomerID=@OlDCustomerID 
END


declare @CurrBalance money

IF (@CustomerID is not null AND @Status>0 ) 
  SET @CurrBalance = isnull((Select BalanceDoe from Customer Where customerid=@CustomerID),0)+isnull(@Debit,0) - isnull(@Credit,0)
ELSE
  SET @CurrBalance = 0


UPDATE [dbo].[Transaction]
   SET [CustomerID] = @CustomerID 
      ,[Debit] = @Debit 
      ,[Credit] = @Credit
      ,[Tax] = @Tax
      ,[TaxType] = @TaxType
      ,[TaxRate] = @TaxRate
      ,[TaxID] = @TaxID
      ,[ShipTo] = @ShipTo
      ,[RecieptTxt] = @RecieptTxt
      ,[Note] = @Note
      ,[Status] = @Status
      ,[DateModified] = dbo.GetLocalDATE()
      ,[UserModified] = @ModifierID
 WHERE TransactionID=@TransactionID


declare @Paid money
declare @PaidDate datetime 



IF (@CustomerID is not null) AND @Status>0 
BEGIN
	if (@Credit - @Debit) >0 begin
	  SET @Paid =(@Credit - @Debit)
	  SET @PaidDate =dbo.GetLocalDATE()
	END
	ELSE BEGIN
	  SET @Paid =null
	  SET @PaidDate =null
	END
	UPDATE Customer set BalanceDoe= (IsNull(BalanceDoe,0)+@Debit-@Credit),DateModified =dbo.GetLocalDATE()
	--,LastPayment =ISNULL(@Paid,LastPayment)
	--,LastPaymentDate=ISNULL(@PaidDate,LastPaymentDate) 
	WHERE CustomerID = @CustomerID
END



COMMIT TRANSACTION;

--exec dbo.ApplyTransacion @TransactionID,@ConnectionStringdatasoft	dsdsds

--	IF (@CustomerID is  null) 
--	BEGIN
--		DECLARE  @PDID UNIQUEIDENTIFIER
--		set @PDID= newid()
--		DECLARE  @AbsCredit money
--		set @AbsCredit= abs(@Credit)
--		exec SP_PaymentDetailsInsert	 @PDID,@TransactionID,@TransactionID,@AbsCredit,null,1,@ModifierID
--	END
GO
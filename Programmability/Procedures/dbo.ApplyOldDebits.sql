SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[ApplyOldDebits]
(@AmountToApply money,
@TransactionID uniqueidentifier,
@CustomerID uniqueidentifier,
@ModifierID uniqueidentifier)

AS

DECLARE @cTransID uniqueidentifier
DECLARE @cDebit money
declare @PDID as uniqueidentifier

DECLARE c11 CURSOR FORWARD_ONLY STATIC OPTIMISTIC FOR
SELECT TransactionID,LeftDebit -- all Transaction that belong to the current customer and have balance that did not paid
FROM dbo.LeftDebitsView WHERE(CustomerID=@CustomerID) AND (LeftDebit>0) and TransactionID<>@TransactionID order by StartSaleTime

OPEN c11

FETCH NEXT FROM c11 
INTO @cTransID,@cDebit -- holds the current transaction and the left debit

WHILE @@FETCH_STATUS = 0
	BEGIN
		IF (@AmountToApply<=0) break --if there is no amount to pay 
		IF (@AmountToApply>@cDebit)
--when the amount is bigger then the current left debit - insert a row and update the amount to apply
 		    begin	
		 	set @PDID= newid()
			exec SP_PaymentDetailsInsert	@PDID,@TransactionID,@cTransID, @cDebit, null ,1,  @ModifierID
			set @AmountToApply=@AmountToApply-@cDebit
		     end
		ELSE
--when the amount is equlas or lower the the current left debit - insert a row and finish the SP 
		     begin

			set @PDID= newid()
			exec SP_PaymentDetailsInsert	@PDID,@TransactionID,@cTransID, @AmountToApply, null ,1,  @ModifierID
                       
			break
		     end

		FETCH NEXT FROM c11   --insert the next values to the instances
		INTO @cTransID,@cDebit
	END

CLOSE c11
DEALLOCATE c11
GO
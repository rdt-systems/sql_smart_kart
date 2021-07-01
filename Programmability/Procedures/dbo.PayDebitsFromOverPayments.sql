SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[PayDebitsFromOverPayments]
(@DebitToPay money,
@TransactionID uniqueidentifier,
@CustomerID uniqueidentifier,
@ModifierID uniqueidentifier)

AS

DECLARE @cTransID uniqueidentifier
DECLARE @cCredit money
DECLARE @PDID uniqueidentifier

DECLARE c10 CURSOR FORWARD_ONLY STATIC OPTIMISTIC FOR
SELECT TransactionID,LeftCredit 
FROM dbo.LeftCreditsView 
where (CustomerID=@CustomerID) AND (LeftCredit>0) And StartSaleTime<=(Select StartSaleTime from [Transaction] Where TransactionID=@TransactionID) order by StartSaleTime

OPEN c10

FETCH NEXT FROM c10
INTO @cTransID,@cCredit

WHILE @@FETCH_STATUS = 0
	BEGIN
		IF (@DebitToPay<=0) break 
		IF (@DebitToPay>@cCredit)
		begin
			set @PDID= newid()
			exec SP_PaymentDetailsInsert	@PDID,@cTransID,@TransactionID, @cCredit, null ,1,  @ModifierID
                        
			/*insert into dbo.PaymentDetails(PaymentID,TransactionID,TransactionPayedID,Amount,Note,Status,DateCREATE,UserCREATE,DateModified,UserModified)
						values(NEWID(),@cTransID,@TransactionID,@cCredit,null,1,dbo.GetLocalDATE(), @ModifierID, dbo.GetLocalDATE(), @ModifierID)*/
			set @DebitToPay=@DebitToPay-@cCredit
		end
		ELSE
		begin

			set @PDID= newid()
			exec SP_PaymentDetailsInsert	@PDID,@cTransID,@TransactionID, @DebitToPay, null ,1,  @ModifierID
                     
			/*insert into dbo.PaymentDetails(PaymentID,TransactionID,TransactionPayedID,Amount,Note,Status,DateCREATE,UserCREATE,DateModified,UserModified)
						values(NEWID(),@cTransID,@TransactionID,@DebitToPay,null,1,dbo.GetLocalDATE(), @ModifierID, dbo.GetLocalDATE(), @ModifierID)*/
			break
		end

		FETCH NEXT FROM c10
		INTO @cTransID,@cCredit
	END

CLOSE c10
DEALLOCATE c10
GO
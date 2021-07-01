SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


--exec SP_ChangeCustomerApply 'c1e5141d-769f-414c-898c-0f04d81c3f1b','c1e5141d-769f-414c-898c-0f04d81c3f1b'
CREATE PROCEDURE [dbo].[SP_ChangeCustomerApply]
(@CustomerID uniqueidentifier--,
--@ModifierID uniqueidentifier
)
as


---------------------------------------------------------Apply openning balance
DECLARE @cTransID uniqueidentifier
DECLARE @cDebitToPay money
DECLARE @cCustomerID uniqueidentifier
DECLARE @cModifierID uniqueidentifier
--
SELECT top 1 @cTransID= TransactionID ,@cDebitToPay=LeftDebit,@cCustomerID=CustomerID,@cModifierID=UserModified 
  --,  ,  , 
FROM [Transaction] where (Status>0) AND (CustomerID =@CustomerID) and leftdebit>0 and TransactionType=2
order by StartSaleTime desc

		exec PayDebitsFromOverPayments @cDebitToPay,@cTransID,@cCustomerID,@cModifierID
--@cDebitToPay,@cTransID,@cCustomerID,@cModifierID
--		FETCH NEXT FROM c100
--		INTO  @cTransID,@cDebitToPay,@cCustomerID,@cModifierID
--	END
--
--CLOSE c100
--DEALLOCATE c100
-------------------------------------------------------------------
--DECLARE @cTransID uniqueidentifier
--DECLARE @cDebitToPay money
--DECLARE @cCustomerID uniqueidentifier
--DECLARE @cModifierID uniqueidentifier

DECLARE c100 CURSOR FORWARD_ONLY STATIC OPTIMISTIC FOR
SELECT TransactionID,LeftDebit,CustomerID,UserModified
FROM [Transaction] where (Status>0) AND (CustomerID =@CustomerID) and leftdebit>0 order by StartSaleTime

OPEN c100

FETCH NEXT FROM c100
INTO @cTransID,@cDebitToPay,@cCustomerID,@cModifierID

WHILE @@FETCH_STATUS = 0
	BEGIN
		exec PayDebitsFromOverPayments @cDebitToPay,@cTransID,@cCustomerID,@cModifierID
		FETCH NEXT FROM c100
		INTO  @cTransID,@cDebitToPay,@cCustomerID,@cModifierID
	END

CLOSE c100
DEALLOCATE c100
GO
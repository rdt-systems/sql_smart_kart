SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE procedure [dbo].[SP_UpdateAfterTransactionInsert]
(@TransactionID uniqueidentifier,
@ApplyType int= 0
)

AS 

DECLARE @Credit  MONEY
DECLARE @Debit  MONEY
DECLARE @StartSaleTime DATETIME

SELECT     CustomerID, Credit, TransactionID, Debit, StartSaleTime
INTO #MyTrans
FROM [Transaction] 
WHERE TransactionID =@TransactionID

SET @Credit = (SELECT #MyTrans.Credit FROM #MyTrans)
SET @Debit = (SELECT #MyTrans.Debit FROM #MyTrans)
declare @CustomerID uniqueidentifier
set @CustomerID= (select CustomerID from #MyTrans WHERE TransactionID =@TransactionID)

--IF @CREDIT <= 0 BEGIN
--  DROP TABLE #MyTrans
--  RETURN
--END

SELECT Customerno,    Over0, Over30, Over60, Over90, Over120
INTO #MyAging
FROM   Customer
WHERE CustomerID = @Customerid

DECLARE @Over120 MONEY  SET @Over120= (SELECT Over120 FROM #MyAging) 
DECLARE @Over90 MONEY  SET @Over90= (SELECT Over90 FROM #MyAging) 
DECLARE @Over60 MONEY  SET @Over60= (SELECT Over60 FROM #MyAging) 
DECLARE @Over30 MONEY  SET @Over30= (SELECT Over30 FROM #MyAging) 
DECLARE @Over0 MONEY  SET @Over0= ((SELECT Over0 FROM #MyAging)+ @Debit)

print CONVERT(varchar(50),@Over0)
print CONVERT(varchar(50),@CREDIT)

if (@CREDIT > @DEBIT) AND (@CREDIT>0) BEGIN
  SET @StartSaleTime = (select StartSaleTime from #MyTrans WHERE TransactionID =@TransactionID)
  UPDATE CUSTOMER SET LastPayment = (@CREDIT-@DEBIT),LastPaymentDate =@StartSaleTime, DateModified=dbo.GetLocalDATE()
  WHERE CUSTOMERID = @CustomerID
END
 
--120
IF (@CREDIT > @Over120) BEGIN
  SET @CREDIT = (@CREDIT - @Over120)
  SET @Over120 = 0
END
ELSE BEGIN
  SET @Over120 = (@Over120-@CREDIT)
  SET @CREDIT = 0
END

--90
IF (@CREDIT > @Over90) BEGIN
  SET @CREDIT = (@CREDIT - @Over90)
  SET @Over90 = 0
END
ELSE BEGIN
  SET @Over90 = (@Over90-@CREDIT)
  SET @CREDIT = 0
END

--60
IF (@CREDIT > @Over60) BEGIN
  SET @CREDIT = (@CREDIT - @Over60)
  SET @Over60 = 0
END
ELSE BEGIN
  SET @Over60 = (@Over60-@CREDIT)
  SET @CREDIT = 0
END

--30
IF (@CREDIT > @Over30) BEGIN
  SET @CREDIT = (@CREDIT - @Over30)
  SET @Over30 = 0
END
ELSE BEGIN
  SET @Over30 = (@Over30-@CREDIT)
  SET @CREDIT = 0
END

--0
IF (@CREDIT > @Over0) BEGIN
  SET @CREDIT = (@CREDIT - @Over0)
  SET @Over0 = 0
END
ELSE BEGIN
  SET @Over0 = (@Over0-@CREDIT)
END

EXEC	[CustomerFixAgingForPOS]
		@CustomerID = @CustomerID,
		@Over0 = @Over0,
		@Over30 = @Over30,
		@Over60 = @Over60,
		@Over90 = @Over90,
		@over120 = @over120


DROP TABLE #MyTrans
DROP TABLE #MyAging
GO
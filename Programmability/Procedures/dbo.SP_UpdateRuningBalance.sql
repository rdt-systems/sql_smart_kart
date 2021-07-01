SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


-- =============================================
-- Author:		NathanErenthal
-- Create date: 1/2/11
-- Description:	Update the runnig balance from TransactionID
-- =============================================
CREATE PROCEDURE [dbo].[SP_UpdateRuningBalance](
				@TransactionID uniqueidentifier)
AS
BEGIN
DECLARE @CustID as uniqueidentifier
DECLARE @TransID as uniqueidentifier
DECLARE @OldBalance as money
DECLARE @Credit as money
DECLARE @Debit as money

DECLARE @StartSaleTime dateTime
SELECT   TOP(1)@CustID=CustomerID,@StartSaleTime=StartSaleTime From dbo.[Transaction] WITH (NOLOCK) where transactionID = @TransactionID
SELECT TOP(1)@OldBalance=IsNull(CurrBalance,0) from dbo.[Transaction] WITH (NOLOCK) where StartSaleTime <@StartSaleTime and CustomerID =@CustID and status>0
ORDER BY  StartSaleTime Desc
SET @OldBalance=IsNull(@OldBalance,0)
--SELECT  @CustID,@OldBalance,@StartSaleTime

declare C cursor  for select TransactionID,Credit,Debit from dbo.[Transaction] WITH (NOLOCK) where Customerid=@CustID and status>0 and StartSaleTime >=@StartSaleTime Order by StartSaleTime
OPEN C

fetch next from C into @TransID,@Credit,@Debit
while @@fetch_status = 0 begin
print @Oldbalance
set @OldBalance =@OldBalance+@Debit-@Credit
UPDATE [Transaction] SET CurrBalance =@OldBalance WHERE Transactionid = @TransID 
fetch next from C into @TransID ,@Credit,@Debit
end
close C 
deallocate C
END
GO
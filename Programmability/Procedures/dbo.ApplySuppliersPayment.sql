SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


Create Procedure [dbo].[ApplySuppliersPayment]
as 

select UserModified,SupplierID,SuppTenderEntryID ,Amount-Isnull((Select Sum(ISnull(Amount,0)) From PayToBill where SuppTenderID=SuppTenderEntryID And Status>0),0) as UnAppliedAmount
Into #T1
from SupplierTenderEntry
where Status> 0 and 
Amount>Isnull((Select Sum(Isnull(Amount,0)) From PayToBill where SuppTenderID=SuppTenderEntryID And Status>0),0)

DECLARE @SupplierID uniqueidentifier
DECLARE @UnAppliedAmount money
declare @SuppTenderEntryID as uniqueidentifier
declare @ModifierID as uniqueidentifier

DECLARE c11 CURSOR FORWARD_ONLY STATIC OPTIMISTIC FOR
SELECT UserModified,SupplierID,UnAppliedAmount,SuppTenderEntryID
FROM dbo.#T1 

OPEN c11

FETCH NEXT FROM c11 
INTO @ModifierID,@SupplierID,@UnAppliedAmount,@SuppTenderEntryID 

DECLARE @PayToBillID uniqueidentifier

WHILE @@FETCH_STATUS = 0
	BEGIN

			DECLARE @BillID uniqueidentifier
			DECLARE @UnPaidAmount money

			DECLARE B11 CURSOR FORWARD_ONLY STATIC OPTIMISTIC FOR
			SELECT BillID,(Isnull(Amount,0)-isnull(AmountPay,0))  
			FROM dbo.Bill WHERE (SupplierID=@SupplierID) And  (Isnull(Amount,0)<>isnull(AmountPay,0)) order by BillDate

			OPEN B11

			FETCH NEXT FROM B11 
			INTO @BillID,@UnPaidAmount 

			WHILE @@FETCH_STATUS = 0
				BEGIN
					IF (@UnAppliedAmount<=0) break 
						IF (@UnAppliedAmount>=@UnPaidAmount)
 							begin	
		 						set @PayToBillID= newid()
								exec [SP_PayToBillInsert]	@PayToBillID,@SuppTenderEntryID,@BillID, @UnPaidAmount, null ,0,1,  @ModifierID
								set @UnAppliedAmount=@UnAppliedAmount-@UnPaidAmount
							end
						ELSE
							 begin
								set @PayToBillID= newid()
								exec [SP_PayToBillInsert]	@PayToBillID,@SuppTenderEntryID,@BillID, @UnAppliedAmount, null ,0,1,  @ModifierID        
							break
						end

					FETCH NEXT FROM B11   
					INTO @BillID,@UnPaidAmount
				END

			CLOSE B11
			DEALLOCATE B11

		FETCH NEXT FROM c11   
		INTO @ModifierID,@SupplierID,@UnAppliedAmount,@SuppTenderEntryID
	END

CLOSE c11
DEALLOCATE c11

drop table #T1
GO
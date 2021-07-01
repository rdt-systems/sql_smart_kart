SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SP_UpdateInvoiceDiscount]
(@TransactionID uniqueidentifier,
@ModifierID uniqueidentifier)
as

Declare @TermsID uniqueidentifier
SET @TermsID =(Select TermsID from [transaction] where TransactionID=@TransactionID)

Declare @DiscPercent as decimal
set @DiscPercent= (Select InterestRate from dbo.Credit where CreditID=@TermsID)

Declare @AmountDisc as money
Set @AmountDisc=round(isnull((Select (TotalEntry) from TransactionsView where TransactionID=@TransactionID)*@DiscPercent/100,0),2)

if (select count(*) from TransactionEntry 
	Where TransactionID=@TransactionID and TransactionEntryType=4 and status>0)=0 -- no discount before
begin
	Declare @ID uniqueidentifier
	SET @ID = NewID()
	Declare @Sort int
	SET @Sort = (Select count(*) from TransactionEntry Where TransactionID=@TransactionID and Status>0)

	insert into TransactionEntry(TransactionEntryID,TransactionID,ItemStoreID,TransactionEntryType,UomPrice,DiscountPerc,qty,Sort,Status,DateCreated,UserCreated)
			values(@ID,@TransactionID,@TermsID,4,@AmountDisc,@DiscPercent,1,@Sort,1,dbo.GetLocalDATE(),@ModifierID)
end
else
Begin
	update TransactionEntry    -- Type Amount
	set UOMPrice=isnull(UOMPrice,0)+@AmountDisc,
		DiscountPerc=DiscountPerc+@DiscPercent,
		DateModified=dbo.GetLocalDATE(),
		UserModified=@ModifierID
	where TransactionID=@TransactionID and TransactionEntryType=4 and status>0
End

update TransactionEntry    -- discount on total
set discountontotal=(select DiscountPerc FROM TransactionEntry where TransactionID=@TransactionID and TransactionEntryType=4 and status>0)
where TransactionID=@TransactionID and status>0

Set @AmountDisc=round(isnull((Select (TotalEntry+tax) from TransactionsView where TransactionID=@TransactionID)*@DiscPercent/100,0),2)

update [Transaction]
set 
	debit=isnull(debit,0)-@AmountDisc,
	LeftDebit=isnull(LeftDebit,0)-@AmountDisc,
	tax=round(isnull(tax,0)-isnull(tax,0)*@DiscPercent/100,2),
	DateModified=dbo.GetLocalDATE(),
	UserModified=@ModifierID
where TransactionID=@TransactionID
GO
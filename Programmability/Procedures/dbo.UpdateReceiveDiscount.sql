SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[UpdateReceiveDiscount]
(@BillID uniqueidentifier)
as
declare @ReceiveID as uniqueidentifier
set @ReceiveID=(select ReceiveID from ReceiveOrderView where BillID=@BillID)

Declare @DiscPercent as decimal
set @DiscPercent= (Select InterestRate from dbo.Credit where CreditID=(Select TermsID from Bill where BillID=@BillID))

Declare @AmountDisc as money
Set @AmountDisc=round(isnull((Select Sum(ExtPrice) from ReceiveEntry where ReceiveNo=@ReceiveID)*isnull(@DiscPercent,0)/100,0),2)

update ReceiveOrder    -- Type Amount
set Discount=isnull(Discount,0)+@DiscPercent,
	Total=Total-@AmountDisc
where REceiveID=@ReceiveID and IsDiscAmount=1 and not Discount is null

update ReceiveOrder    -- Type Percent
set Discount=isnull(Discount,0)+@DiscPercent,
	Total=Total-@AmountDisc
where REceiveID=@ReceiveID and IsDiscAmount=0 and not Discount is null

update ReceiveOrder    -- null
set Discount=@DiscPercent,
	IsDiscAmount=0,
	Total=Total-@AmountDisc
where REceiveID=@ReceiveID and IsDiscAmount=0 and  Discount is null

Update Bill
set Amount=Amount-@AmountDisc
where BillID=@BillID
GO
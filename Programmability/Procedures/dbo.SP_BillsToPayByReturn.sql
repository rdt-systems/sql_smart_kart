﻿SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SP_BillsToPayByReturn]
(@ID uniqueidentifier,
@StoreID uniqueidentifier,
@PaymentDate Datetime)
AS 

declare @Sort as Bit 
set @Sort = (select OptionValue from SetUpValues Where StoreID = @StoreID and  OptionName='Auto Apply')
if @Sort = 0
	SELECT     BillID, BillNo, Amount, AmountPay, BillDate,
               ISNULL(Amount - AmountPay, 0)
			   AS Balance,
			   0.00 AS ApplyAmount 
	FROM         dbo.BillWithStoreID Left Outer join
				 dbo.Credit On dbo.Credit.CreditID=BillWithStoreID.TermsID and dbo.Credit.Status>0
	WHERE     (dbo.BillWithStoreID.Status >0) and (dbo.BillWithStoreID.ReceiveStatus >0) AND (SupplierID = @ID) AND (ISNULL(Amount - AmountPay, 0) > 0)
	ORDER BY BillDate DESC
else
	SELECT     BillID, BillNo, Amount, AmountPay, BillDate,
                   ISNULL(Amount - AmountPay, 0) 
			       AS Balance,
			       0.00 AS ApplyAmount 
	FROM         dbo.BillWithStoreID Left Outer join
				 dbo.Credit On dbo.Credit.CreditID=BillWithStoreID.TermsID and dbo.Credit.Status>0
	WHERE       (dbo.BillWithStoreID.Status >0) and (dbo.BillWithStoreID.ReceiveStatus >0) AND (SupplierID = @ID) AND (ISNULL(Amount - AmountPay, 0) > 0)
	ORDER BY BillDate asc
GO
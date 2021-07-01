SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SP_PPCompInsert]
(@PPCompID uniqueidentifier,
@PPCName nvarchar(50),
@InvoiceNum nvarchar(50),
@ReturnNum nvarchar(50),
@PaymentNum nvarchar(50),
@SaleOrderNum nvarchar(50),
@ReceiveNum nvarchar(50),
@ReturnSupplierNum nvarchar(50),
@PaymentSupplierNum nvarchar(50),
@ModifierID uniqueidentifier,
@Status smallint)
AS INSERT INTO dbo.PPComp
			(PPCompID,
			 PPCName, 
			 InvoiceNum, 
			 ReturnNum, 
			 PaymentNum, 
			 ReceiveNum,
			 SaleOrderNum, 
			 ReturnSupplierNum, 
			 PaymentSupplierNum, 
			 Status, 
			 DateCreated, 
			 UserCreated, 
			 DateModified, 
			 UserModified)
VALUES     (@PPCompID, 
		    dbo.CheckString(@PPCName),
		    @InvoiceNum, 
		    @ReturnNum, 
		    @PaymentNum,
			@SaleOrderNum,
		    @ReceiveNum, 
		    @ReturnSupplierNum, 
			@PaymentSupplierNum, 
		    1, 
			dbo.GetLocalDATE(), 
			@ModifierID, 
			dbo.GetLocalDATE(),
			@ModifierID)
GO
SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[WEB_SaleOrderInsert]
(@TransactionID uniqueidentifier,
@TransactionType int,
@StoreID uniqueidentifier,
@CustomerID uniqueidentifier,
@Debit money,
@Credit money,
@StartSaleTime datetime,
@EndSaleTime datetime,
@DueDate datetime,
@ShipTo uniqueidentifier,
@ShipVia uniqueidentifier,
@PhoneOrder bit,
@ToPrint bit,
@ToEmail bit,
@Status smallint,
@ModifierID uniqueidentifier,
@RecieptTxt text)

AS 


declare @CurrBalance money


INSERT INTO dbo.[Transaction]--to work order
 (TransactionID,  TransactionType,  StoreID, CustomerID,  
Debit, Credit, StartSaleTime,EndSaleTime,  ShipTo, ShipVia,
PhoneOrder,ToPrint,ToEmail,
Status, DateCreated, UserCreated, DateModified, UserModified,CurrBalance,RecieptTxt)

VALUES     		
(@TransactionID, @TransactionType,  @StoreID, @CustomerID,  
@Debit, @Credit, @StartSaleTime,@EndSaleTime,   @ShipTo, @ShipVia,
@PhoneOrder,@ToPrint,@ToEmail,
 1, dbo.GetLocalDATE(), @ModifierID, dbo.GetLocalDATE(), @ModifierID,@CurrBalance,@RecieptTxt)
GO
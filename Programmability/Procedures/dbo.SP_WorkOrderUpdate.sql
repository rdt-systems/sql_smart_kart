SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SP_WorkOrderUpdate]
(@WorkOrderID uniqueidentifier,
@ActiveDate datetime,
@ExpirationDate datetime,
@WONo nvarchar(50),
@StoreID uniqueidentifier,
@CustomerID uniqueidentifier,
@Debit money,
@StartSaleTime datetime,
@EndSaleTime datetime,
@Tax money,
@TaxType nvarchar(50),
@TaxRate decimal(19,4),
@TaxID uniqueidentifier,
@ShipTo uniqueidentifier,
@ShipVia uniqueidentifier,
@Note nvarchar(4000),
@WOStatus smallint,
@Pay_TenderType int,
@Pay_PaymentType	smallint,		
@Pay_CardNumber	nvarchar(50),	
@Pay_NameOnCard	nvarchar(50),	
@Pay_ExpirationDate datetime,		
@Pay_SecurityCode nvarchar(50),
@IsWeb bit,
@Freight money,
@Status smallint,
@DateModified datetime,
@ModifierID uniqueidentifier,
@ResellerID uniqueIdentifier)

AS 
UPDATE dbo.WorkOrder
SET              	
		ActiveDate=@ActiveDate,  
		ExpirationDate =@ExpirationDate  ,
		WONo=@WONo,    
		StoreID=@StoreID,
		CustomerID=@CustomerID,
	        	DeBit=@DeBit, 
		StartSaleTime =@StartSaleTime,
		EndSaleTime =@EndSaleTime,
		Tax =@Tax,
		TaxType =@TaxType,
		TaxRate=@TaxRate,
		TaxID =@TaxID,
		ShipTo=@ShipTo,
		ShipVia =@ShipVia,
		Note =@Note,
		WOStatus=@WOStatus,
		Pay_TenderType=@Pay_TenderType,
		Pay_PaymentType=@Pay_PaymentType,	
		Pay_CardNumber	=@Pay_CardNumber,
		Pay_NameOnCard	=@Pay_NameOnCard,
		Pay_ExpirationDate =@Pay_ExpirationDate,
		Pay_SecurityCode =@Pay_SecurityCode,
		IsWeb=@IsWeb,
		Freight=@Freight,
		ResellerID=@ResellerID,
		Status=@Status,
		DateModified=dbo.GetLocalDATE(),
		UserModified=@ModifierID
WHERE
	WorkOrderID=@WorkOrderID
GO
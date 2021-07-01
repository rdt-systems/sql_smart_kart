SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SP_WorkOrderInsert]
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
@Pay_PaymentType smallint,		
@Pay_CardNumber	nvarchar(50),	
@Pay_NameOnCard	nvarchar(50),	
@Pay_ExpirationDate datetime,		
@Pay_SecurityCode nvarchar(50),	
@IsWeb bit,
@Freight money,
@Status smallint,
@ModifierID uniqueidentifier,
@ResellerID uniqueIdentifier,
@DateCreated datetime=null,
@UserCreated uniqueIdentifier=null)

AS 

if @StoreId is null
set @STOREID=(SELECT TOP 1 STOREID FROM STORE)

INSERT INTO dbo.WorkOrder
                       
         (WorkOrderID,ActiveDate,  ExpirationDate   ,WONo,    StoreID,CustomerID,
	  DeBit,  StartSaleTime ,EndSaleTime ,Tax ,TaxType ,TaxRate,TaxID ,ShipTo,ShipVia ,Note ,WOStatus,
	  Pay_TenderType,Pay_PaymentType,Pay_CardNumber,Pay_NameOnCard	,Pay_ExpirationDate ,Pay_SecurityCode ,IsWeb,Freight,
	  ResellerID, Status,DateCreated,UserCreated,DateModified,UserModified)

VALUES     (@WorkOrderID, @ActiveDate ,@ExpirationDate ,@WONo ,@StoreID ,@CustomerID,
	       @Debit,@StartSaleTime ,@EndSaleTime ,@Tax ,@TaxType,@TaxRate ,@TaxID ,
	       @ShipTo,@ShipVia ,@Note ,isnull(@WOStatus,1),
	       @Pay_TenderType,@Pay_PaymentType,@Pay_CardNumber,@Pay_NameOnCard,@Pay_ExpirationDate ,@Pay_SecurityCode ,@IsWeb,@Freight,
	       @ResellerID, 1, isnull (@DateCreated,dbo.GetLocalDATE()) ,isnull(@UserCreated,@ModifierID),  dbo.GetLocalDATE(),  @ModifierID)
GO
SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[WEB_GetWorkOrderDetails] 
(@WorkID uniqueidentifier)
AS
	
SELECT    StartSaleTime,Pay_PaymentType,Pay_CardNumber,Pay_NameOnCard,
Pay_ExpirationDate,Pay_SecurityCode,
WONo,Debit,Freight,WorkOrderID,ShipTo,DateCreated
FROM         workorder
where status>0
 and WorkOrderID=@WorkID
GO
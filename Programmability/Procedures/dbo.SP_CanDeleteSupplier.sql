SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SP_CanDeleteSupplier]
(@SupplierID uniqueidentifier)
As 

if 
(select Count(1) from dbo.PurchaseOrdersView
where SupplierNo = @SupplierID and Status>-1 )+ 
(select Count(1) from dbo.ReceiveOrderView
where SupplierNo = @SupplierID and Status>-1 )+ 
(select Count(1) from dbo.SupplierTenderEntry
where SupplierID = @SupplierID and Status>-1 )+ 
(select Count(1) from dbo.ReturnToVenderView
where SupplierID = @SupplierID and Status>-1)+
(select Count(1) from dbo.ItemSupplyView
where SupplierNo = @SupplierID and Status>-1)=0
	select 1
else
	select 0
GO
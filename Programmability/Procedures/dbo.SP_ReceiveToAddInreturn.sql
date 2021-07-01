SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SP_ReceiveToAddInreturn]
@Filter nvarchar(4000)
 
AS
declare @MySelect nvarchar(4000)
set @MySelect= 'select dbo.ReceiveOrderView.ReceiveID,dbo.ReceiveOrderView.BillNo,dbo.ReceiveOrderView.StoreID,dbo.ReceiveOrderView.SupplierNo,dbo.ReceiveOrderView.BillDate,dbo.Supplier.Name as SupplierName
                from dbo.ReceiveOrderView left OUTER  join
                dbo.Supplier ON dbo.ReceiveOrderView.SupplierNo = dbo.Supplier.SupplierID
                where dbo.ReceiveOrderView.Status>0 And dbo.ReceiveOrderView.Amount-dbo.ReceiveOrderView.AmountPay>0'
Execute (@MySelect + @Filter )
GO
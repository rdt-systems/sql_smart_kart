SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE VIEW [dbo].[PPCompView]
AS
SELECT     PPCompID, PPCName, InvoiceNum, ReturnNum, PaymentNum, SaleOrderNum, ReceiveNum, ReturnSupplierNum, PaymentSupplierNum, Status, 
                      DateCreated, UserCreated, DateModified, UserModified
FROM         dbo.PPComp
GO
SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE VIEW [dbo].[ReturnToVenderView]
AS
SELECT     ReturnToVenderID, ReturnToVenderNo, StoreNo, SupplierID, PersonReturnID, Total, Note, ReturnToVenderDate, Taxable, TaxRate, TaxAmount, Status, 
                      DateCreated, UserCreated, DateModified, UserModified, Discount, IsDiscountInAmount
FROM         dbo.ReturnToVender
GO
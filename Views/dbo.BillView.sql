SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE VIEW [dbo].[BillView]
AS
SELECT     BillID, BillNo, SupplierID, Discount, Amount, AmountPay, BillDate, BillDue, PersonGet, TermsID, Note, Taxable, TaxRate, TaxAmount, Status, 
                      DateCreated, UserCreated, DateModified, UserModified
FROM         dbo.Bill
GO
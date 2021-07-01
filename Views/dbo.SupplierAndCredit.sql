SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


Create view [dbo].[SupplierAndCredit]
as
SELECT     SupplierID,[Name],isnull((Select NetDue from Credit where Supplier.DefaultCredit=Credit.CreditID),0)as NetDue ,isnull((Select DayInMonth from Credit where Supplier.DefaultCredit=Credit.CreditID),0)as DayInMonth,(Select CreditType from Credit where Supplier.DefaultCredit=Credit.CreditID) as CreditType
FROM         dbo.Supplier
WHERE     (Status > - 1)
GO
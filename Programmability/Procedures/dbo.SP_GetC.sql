SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE procedure [dbo].[SP_GetC]
(@Filter nvarchar(4000),
@Item bit =0)
as
declare @MySelect nvarchar(4000)
if @Item=0
begin
set @MySelect= 'select distinct  dbo.CustomerFilter.CustomerID, dbo.CustomerFilter.CustomerNo, dbo.CustomerFilter.ClubID, dbo.CustomerFilter.MainAddressID, 
                      dbo.CustomerFilter.SortOrder, dbo.CustomerFilter.SalesPersonID, dbo.CustomerFilter.CustomerType, dbo.CustomerFilter.Credit, 
                      dbo.CustomerFilter.CreditByAnyone, dbo.CustomerFilter.TaxID, dbo.CustomerFilter.CreditByManger, dbo.CustomerFilter.CreditByAdmin, 
                      dbo.CustomerFilter.TermDays, dbo.CustomerFilter.TermDiscount, dbo.CustomerFilter.PriceLevelID, dbo.CustomerFilter.CreditCardID, 
                      dbo.CustomerFilter.CreditCardNO, dbo.CustomerFilter.CSV, dbo.CustomerFilter.CCExpDate, dbo.CustomerFilter.DriverLicenseNo, 
                      dbo.CustomerFilter.State, dbo.CustomerFilter.SocialSecurytyNO, dbo.CustomerFilter.Password, dbo.CustomerFilter.Statment, 
                      dbo.CustomerFilter.CheckAccept, dbo.CustomerFilter.EnforceCreditLimit, dbo.CustomerFilter.EnforceCheckSign, dbo.CustomerFilter.OnMailingList, 
                      dbo.CustomerFilter.FaxNumber, dbo.CustomerFilter.Contact1, dbo.CustomerFilter.Contact2, dbo.CustomerFilter.Status, dbo.CustomerFilter.BalanceDoe, 
                      dbo.CustomerFilter.Name
                                 from CustomerFilter 
				where (1=1) '
Execute (@MySelect + @Filter )
end
Else
begin
set @MySelect='select distinct  dbo.CustomerFilter.CustomerID, dbo.CustomerFilter.CustomerNo, dbo.CustomerFilter.ClubID, dbo.CustomerFilter.MainAddressID, 
                      dbo.CustomerFilter.SortOrder, dbo.CustomerFilter.SalesPersonID, dbo.CustomerFilter.CustomerType, dbo.CustomerFilter.Credit, 
                      dbo.CustomerFilter.CreditByAnyone, dbo.CustomerFilter.TaxID, dbo.CustomerFilter.CreditByManger, dbo.CustomerFilter.CreditByAdmin, 
                      dbo.CustomerFilter.TermDays, dbo.CustomerFilter.TermDiscount, dbo.CustomerFilter.PriceLevelID, dbo.CustomerFilter.CreditCardID, 
                      dbo.CustomerFilter.CreditCardNO, dbo.CustomerFilter.CSV, dbo.CustomerFilter.CCExpDate, dbo.CustomerFilter.DriverLicenseNo, 
                      dbo.CustomerFilter.State, dbo.CustomerFilter.SocialSecurytyNO, dbo.CustomerFilter.Password, dbo.CustomerFilter.Statment, 
                      dbo.CustomerFilter.CheckAccept, dbo.CustomerFilter.EnforceCreditLimit, dbo.CustomerFilter.EnforceCheckSign, dbo.CustomerFilter.OnMailingList, 
                      dbo.CustomerFilter.FaxNumber, dbo.CustomerFilter.Contact1, dbo.CustomerFilter.Contact2, dbo.CustomerFilter.Status, dbo.CustomerFilter.BalanceDoe, 
                      dbo.CustomerFilter.Name,dbo.CustomerItemFilterView.ItemStoreID,dbo.CustomerItemFilterView.SupplierName ,dbo.CustomerItemFilterView.Name ,dbo.CustomerItemFilterView. ManufacturerName
                                 from CustomerFilter ,CustomerItemFilterView
				where (1=1) and   dbo.CustomerFilter.CusomerID=  dbo.CustomerItemFilterView.CustomerID '
Execute (@MySelect + @Filter )
end
GO
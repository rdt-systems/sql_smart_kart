SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE procedure [dbo].[SP_GetCRMView]
(@Filter nvarchar(4000),
@Item bit =0,
@CustBalance bit=0)
as
declare @MySelect nvarchar(4000)
if @Item=0 and @CustBalance=0
	begin
	set @MySelect= 'SELECT  * FROM CRMVIEW WHERE (1 = 1)'
	PRINT(@MySelect + @Filter )
	Execute (@MySelect + @Filter )
	end
Else
	begin
	if @CustBalance=0
		begin
		set @MySelect= 'select distinct  dbo.CustomerFilter.CustomerID, dbo.CustomerFilter.CustomerNo, dbo.CustomerFilter.ClubID, dbo.CustomerFilter.MainAddressID, 
		                      dbo.CustomerFilter.SortOrder, dbo.CustomerFilter.SalesPersonID, dbo.CustomerFilter.CustomerType, dbo.CustomerFilter.Credit, 
		                      dbo.CustomerFilter.TaxID, dbo.CustomerFilter.CreditLevel1, dbo.CustomerFilter.CreditLevel2, dbo.CustomerFilter.CreditLevel3,  
		                      dbo.CustomerFilter.TermDays, dbo.CustomerFilter.TermDiscount, dbo.CustomerFilter.PriceLevelID, dbo.CustomerFilter.CreditCardID, 
		                      dbo.CustomerFilter.CreditCardNO, dbo.CustomerFilter.CSV, dbo.CustomerFilter.CCExpDate, dbo.CustomerFilter.DriverLicenseNo, 
		                      dbo.CustomerFilter.State, dbo.CustomerFilter.SocialSecurytyNO, dbo.CustomerFilter.Password, dbo.CustomerFilter.Statment, 
		                      dbo.CustomerFilter.CheckAccept, dbo.CustomerFilter.EnforceCreditLimit, dbo.CustomerFilter.EnforceCheckSign, dbo.CustomerFilter.OnMailingList, 
		                      dbo.CustomerFilter.FaxNumber, dbo.CustomerFilter.Contact1, dbo.CustomerFilter.Contact2, dbo.CustomerFilter.Status, dbo.CustomerFilter.BalanceDoe, 
		                      dbo.CustomerFilter.Name,dbo.CustomerFilter.Phone,dbo.CustomerFilter.Address,dbo.CustomerFilter.CityStateAndZip,
							  dbo.CustomerFilter.Over0,dbo.CustomerFilter.Over30,dbo.CustomerFilter.Over60,dbo.CustomerFilter.Over90,dbo.CustomerFilter.Over120,dbo.CustomerFilter.[Current],
							  dbo.CustomerFilter.TaxExempt,dbo.CustomerFilter.TaxNumber, dbo.CustomerFilter.FoodStampNo, dbo.CustomerFilter.FoodStampCode, dbo.CustomerFilter.EnforceSignOnAccount, dbo.CustomerFilter.LockAccount, 
							  dbo.CustomerFilter.LockOutDays,CustomerFilter.StartBalance,CustomerFilter.InActiveReason,CustomerFilter.Email
	                                 from CustomerFilter,CustomerItemFilterView
						where CustomerFilter.CustomerID=CustomerItemFilterView.CustomerID '
		PRINT(@MySelect + @Filter )
		Execute (@MySelect + @Filter )
		end
	if  @CustBalance<>0
	begin
		set @MySelect= 'select distinct  dbo.CustomerFilter.CustomerID, dbo.CustomerFilter.CustomerNo, dbo.CustomerFilter.ClubID, dbo.CustomerFilter.MainAddressID, 
		                      dbo.CustomerFilter.SortOrder, dbo.CustomerFilter.SalesPersonID, dbo.CustomerFilter.CustomerType, dbo.CustomerFilter.Credit, 
		                      dbo.CustomerFilter.TaxID, dbo.CustomerFilter.CreditLevel1, dbo.CustomerFilter.CreditLevel2, dbo.CustomerFilter.CreditLevel3,  
		                      dbo.CustomerFilter.TermDays, dbo.CustomerFilter.TermDiscount, dbo.CustomerFilter.PriceLevelID, dbo.CustomerFilter.CreditCardID, 
		                      dbo.CustomerFilter.CreditCardNO, dbo.CustomerFilter.CSV, dbo.CustomerFilter.CCExpDate, dbo.CustomerFilter.DriverLicenseNo, 
		                      dbo.CustomerFilter.State, dbo.CustomerFilter.SocialSecurytyNO, dbo.CustomerFilter.Password, dbo.CustomerFilter.Statment, 
		                      dbo.CustomerFilter.CheckAccept, dbo.CustomerFilter.EnforceCreditLimit, dbo.CustomerFilter.EnforceCheckSign, dbo.CustomerFilter.OnMailingList, 
		                      dbo.CustomerFilter.FaxNumber, dbo.CustomerFilter.Contact1, dbo.CustomerFilter.Contact2, dbo.CustomerFilter.Status, dbo.CustomerFilter.BalanceDoe, 
		                      dbo.CustomerFilter.Name,dbo.CustomerFilter.PhoneNumber1 as Phone,dbo.CustomerFilter.Street1 as Address,dbo.CustomerFilter.CityStateAndZip,
							  dbo.CustomerFilter.Over0,dbo.CustomerFilter.Over30,dbo.CustomerFilter.Over60,dbo.CustomerFilter.Over90,dbo.CustomerFilter.Over120,dbo.CustomerFilter.[Current],
							  dbo.CustomerFilter.TaxExempt, dbo.CustomerFilter.TaxNumber, dbo.CustomerFilter.FoodStampNo, dbo.CustomerFilter.FoodStampCode, dbo.CustomerFilter.EnforceSignOnAccount, dbo.CustomerFilter.LockAccount, 
							  dbo.CustomerFilter.LockOutDays,CustomerFilter.StartBalance,CustomerFilter.InActiveReason,CustomerFilter.Email
	                                 from CustomerFilter,CustomerItemFilterView
						where (1=1) and CustomerFilter.CustomerID=CustomerItemFilterView.CustomerID '
		PRINT(@MySelect + @Filter )
		Execute (@MySelect + @Filter )
	end

end
GO
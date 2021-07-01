SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE procedure [dbo].[SP_GetCustomers]      
(@Filter nvarchar(4000),      
@Item bit =0,      
@CustBalance bit=0,      
@Statid Int=null,      
@UserId uniqueidentifier=null,      
@StoreID uniqueidentifier=null)      
as      
declare @MySelect nvarchar(4000)      
if @Item=0 and @CustBalance=0      
BEGIN      
 set @MySelect= 'SELECT DISTINCT       
 CustomerID,FirstName, LastName, CustomerNo, ClubID, MainAddressID, SortOrder, SalesPersonID, CustomerType, Credit, TaxID, CreditLevel1, CreditLevel2, CreditLevel3, TermDays,       
 TermDiscount, PriceLevelID, CreditCardID, CreditCardNO, CSV, CCExpDate, DriverLicenseNo, State, SocialSecurytyNO, Password, Statment, CheckAccept,       
 EnforceCreditLimit, EnforceCheckSign, OnMailingList, FaxNumber, Contact1, Contact2, Status, BalanceDoe, Name, Phone, Address, CityStateAndZip, Over0, Over30,       
 Over60, Over90, Over120, [Current], TaxExempt, TaxNumber, FoodStampNo, FoodStampCode, EnforceSignOnAccount, LockAccount, LockOutDays, StartBalance,       
 InActiveReason, Email, Discount, SState, AccountNo, Email_old, DayOfMounth, RegularPaymentType, StoreOpen,StoreCreated,HouseNo,StreetName,LastVisit,LastDateCleared,City,Zip,note,LastPayment,NoBalance       
 FROM CustomerFilter WHERE     (1 = 1)  '      
      
 if @Statid is not null      
 BEGIN       
  Create table #TempItems(CustomerID uniqueidentifier)      
  insert into #TempItems exec [SP_RunGetStatsTblItems]  @StoreID =@StoreID ,@Statid=@Statid, @UserId=@UserId      
      
  set @MySelect=@MySelect +' and CustomerID in ( '+ 'select * from #TempItems)'  
  print @MySelect + @Filter  
  Execute (@MySelect + @Filter )   
  drop table #TempItems      
 END      
 ELSE    
 BEGIN    
  print @MySelect + @Filter      
  Execute (@MySelect + @Filter )     
 END     
END      
Else      
BEGIN      
 if @CustBalance=0      
 BEGIN    
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
         dbo.CustomerFilter.LockOutDays,CustomerFilter.StartBalance,CustomerFilter.InActiveReason,CustomerFilter.Email,dbo.CustomerFilter.SState, dbo.CustomerFilter.AccountNo, dbo.CustomerFilter.Email_old, dbo.CustomerFilter.DayOfMounth, dbo.CustomerFilte
  
    
 r.RegularPaymentType, dbo.CustomerFilter.StoreOpen, dbo.CustomerFilter.StoreCreated, dbo.CustomerFilter.HouseNo, dbo.CustomerFilter.StreetName, dbo.CustomerFilter.LastVisit, dbo.CustomerFilter.LastDateCleared, dbo.CustomerFilter.City, dbo.CustomerFilter.
Z  
    
 ip, dbo.CustomerFilter.note, dbo.CustomerFilter.LastPayment, dbo.CustomerFilter.NoBalance       
           from CustomerFilter,CustomerItemFilterView      
    where CustomerFilter.CustomerID=CustomerItemFilterView.CustomerID '      
   print @MySelect + @Filter      
   Execute (@MySelect + @Filter )      
 END    
     
 IF  @CustBalance<>0      
 BEGIN      
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
    dbo.CustomerFilter.LockOutDays,CustomerFilter.StartBalance,CustomerFilter.InActiveReason,CustomerFilter.Email,dbo.CustomerFilter.SState, dbo.CustomerFilter.AccountNo, dbo.CustomerFilter.Email_old, dbo.CustomerFilter.DayOfMounth, dbo.CustomerFilte  
    
  r.RegularPaymentType, dbo.CustomerFilter.StoreOpen, dbo.CustomerFilter.StoreCreated, dbo.CustomerFilter.HouseNo, dbo.CustomerFilter.StreetName, dbo.CustomerFilter.LastVisit, dbo.CustomerFilter.LastDateCleared, dbo.CustomerFilter.City, dbo.CustomerFilter
.Z  
    
  ip, dbo.CustomerFilter.note, dbo.CustomerFilter.LastPayment, dbo.CustomerFilter.NoBalance       
          from CustomerFilter,CustomerItemFilterView      
   where (1=1) and CustomerFilter.CustomerID=CustomerItemFilterView.CustomerID '      
  print @MySelect + @Filter      
  Execute (@MySelect + @Filter )      
 END       
END
GO
SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE procedure [dbo].[SP_GetAllCustomers]
(@Date datetime=null,
@ShowOnlyInvoice  bit=0,
@Filter nvarchar(4000)
)
as


Declare @MyStreet1 nvarchar(100)
IF (Select COUNT(1) from SetupValues Where OptionID = 299 And StoreID <> '00000000-0000-0000-0000-000000000000' And (OptionValue = '1' OR OptionValue = 'True')) > 0
Set @MyStreet1 = 'ISNULL(street1,'''') + '' '' + ISNULL(street2,'''')'
Else SET @MyStreet1 = 'ISNULL(street1,'''') '

declare @OnlyOpenSelect nvarchar(1000)
IF @ShowOnlyInvoice =1
	SET @OnlyOpenSelect ='-IsNull((SELECT  SUM(PaymentDetails.Amount) AS Paid
							FROM         PaymentDetails INNER JOIN
												  [Transaction] ON PaymentDetails.TransactionID = [Transaction].TransactionID INNER JOIN
												  [Transaction] AS PaidNo ON PaymentDetails.TransactionPayedID = PaidNo.TransactionID
							WHERE     ([Transaction].CustomerID = CustomerView.CustomerID) AND (CONVERT(varchar, ISNULL([Transaction].EndSaleTime, [Transaction].StartSaleTime), 
												  120) > '''+convert(varchar, isnull(@Date,'1753-01-01'),120)+''') AND ([Transaction].CustomerID = CustomerView.CustomerID) AND (CONVERT(varchar, ISNULL(PaidNo.EndSaleTime, 
												  PaidNo.StartSaleTime), 120) < '''+convert(varchar, isnull(@Date,'1753-01-01'),120)+''') AND ([Transaction].Status > 0) AND (PaidNo.Status > 0)),0) '
ELSE
	SET @OnlyOpenSelect ='' 
  
  
declare @MySelect nvarchar(4000)
SET @MySelect= 'select  
			customerview.[name] as CustName,faxnumber,customerview.CustomerNo,
			CONVERT(decimal(19,2),over0) as over0,  
			CONVERT(decimal(19,2),over30) as over30,  
			CONVERT(decimal(19,2),over60) as over60, 
		    CONVERT(decimal(19,2),over90)as over90,  
			 CONVERT(decimal(19,2),over120) as over120 ,'+@MyStreet1+' AS Street1,  
			CONVERT(decimal(19,2),[Current]) as [current],c.city,
			c.state,c.zip,
           	c.city + '' / ''+c.state +'' / ''+ c.zip as CityStateZip,
			c.country,c.phonenumber1,
			Customerview.CustomerID, ISNULL((Select SUM(ISNULL(Debit,0)) - SUM(ISNULL(Credit,0)) From [Transaction]  WHERE        (Status > 0) AND (CustomerID = CustomerView.CustomerID) AND convert(varchar,(ISNULL(EndSaleTime, StartSaleTime)),120)
						 < '''+convert(varchar, isnull(@Date,'1753-01-01'),120)+'''
						),0)'+ @OnlyOpenSelect +
						'as BeginBalance,BalanceDoe,Contact1,Contact2
						
		from customerview	 left outer join customeraddresses c on
			 customerview.customerid = c.customerid
			and c.status>-1 and addresstype=6 
			where customerview.status > 0 AND IsNull(customerview.Statment,0)=0'
            --(customerview.balancedoe>=@Balance or @Balance is null)
			--and (customerview.balancedoe<> case when isnull(@Zero,1)<>0 then customerview.balancedoe-1 else 0 end)
			-- and 

			if  CHARINDEX( 'AND  Customerview.CUSTOMERID IN(Select CustomerID FROM [CustomerIDs])', @filter, 1)>1
			begin 
			set @MySelect =@MySelect+ ' AND  Customerview.CUSTOMERID IN(Select CustomerID FROM [CustomerIDs])  '
			end  
 


print(@MySelect)

	
exec(@MySelect+@Filter)
delete from [CustomerIDs]
GO
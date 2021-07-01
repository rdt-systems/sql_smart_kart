SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SP_PrintCustomer]
(@CustomerID  uniqueidentifier,
@Ship uniqueidentifier=null,
@Date datetime=null,
@Filter nvarchar(4000)='',
@ShowOnlyInvoice  bit=0
)

AS

declare @OnlyOpenSelect nvarchar(1000)
IF @ShowOnlyInvoice =1
	SET @OnlyOpenSelect ='-(SELECT  SUM(PaymentDetails.Amount) AS Paid
							FROM         PaymentDetails INNER JOIN
												  [Transaction] ON PaymentDetails.TransactionID = [Transaction].TransactionID INNER JOIN
												  [Transaction] AS PaidNo ON PaymentDetails.TransactionPayedID = PaidNo.TransactionID
							WHERE     ([Transaction].CustomerID = CustomerView.CustomerID) AND (CONVERT(varchar, ISNULL([Transaction].EndSaleTime, [Transaction].StartSaleTime), 
												  120) > '''+convert(varchar, isnull(@Date,'1753-01-01'),120)+''') AND ([Transaction].CustomerID = CustomerView.CustomerID) AND (CONVERT(varchar, ISNULL(PaidNo.EndSaleTime, 
												  PaidNo.StartSaleTime), 120) < '''+convert(varchar, isnull(@Date,'1753-01-01'),120)+''') AND ([Transaction].Status > 0) AND (PaidNo.Status > 0)) '
ELSE
	SET @OnlyOpenSelect ='' 

Declare @MyStreet1 nvarchar(100)
IF (Select COUNT(1) from SetupValues Where OptionID = 299 And StoreID <> '00000000-0000-0000-0000-000000000000' And (OptionValue = '1' OR OptionValue = 'True')) > 0
Set @MyStreet1 = 'ISNULL(street1,'''') + '' '' + ISNULL(street2,'''')'
Else SET @MyStreet1 = 'ISNULL(street1,'''') '

declare @MySelect nvarchar(4000)
if @Ship is null
		set @MySelect=
                       'select  
			customerview.[name] as CustName,faxnumber,customerview.CustomerNo,CONVERT(decimal(19,2),over0) as over0,  
			CONVERT(decimal(19,2),over30) as over30,  CONVERT(decimal(19,2),over60) as over60, 
		        CONVERT(decimal(19,2),over90)as over90,   CONVERT(decimal(19,2),over120) as over120 ,  ' + @MyStreet1 +  '  AS Street1, street2, 
			CONVERT(decimal(19,2),[Current]) as [current],customeraddresses.city,customeraddresses.state,customeraddresses.zip,
				customeraddresses.city + '' / ''+customeraddresses.state +'' / ''+ customeraddresses.zip as CityStateZip,
			country,phonenumber1,Contact1,Contact2,
			Customerview.CustomerID, ISNULL((Select SUM(ISNULL(Debit,0)) - SUM(ISNULL(Credit,0)) From [Transaction]  WHERE        (Status > 0) AND (CustomerID = CustomerView.CustomerID) AND convert(varchar,(ISNULL(EndSaleTime, StartSaleTime)),120)
						 < '''+convert(varchar, isnull(@Date,'1753-01-01'),120)+'''
						),0) '+@OnlyOpenSelect+ 'as BeginBalance, BalanceDoe			
			from customerview left outer join customeraddresses on customerview.customerid = customeraddresses.customerid
			and customeraddresses.status>-1 and addresstype=6
			where 
			customerview.customerid=''' +cast(@CustomerID as varchar(100)) +'''and
			customerview.status > 0 '
			 
Else
set @MySelect='select  
			customerview.[name] as CustName,faxnumber,customerview.CustomerNo,
			CONVERT(decimal(19,2),over0) as over0,   CONVERT(decimal(19,2),over30) as over30, 
			  CONVERT(decimal(19,2),over60) as over60,   CONVERT(decimal(19,2),over90)as over90, 
			  CONVERT(decimal(19,2),over120) as over120 ,  ' + @MyStreet1 +  '     AS Street1, street2,  CONVERT(decimal(19,2),[Current]) as [current],
			customeraddresses.city,customeraddresses.state,customeraddresses.zip,
				customeraddresses.city + '' / ''+customeraddresses.state +'' / ''+ customeraddresses.zip as CityStateZip,
			country,phonenumber1, customerview.CustomerID,Contact1,Contact2,
ISNULL((Select SUM(ISNULL(Debit,0)) - SUM(ISNULL(Credit,0)) From [Transaction]  WHERE        (Status > 0) AND (CustomerID = CustomerView.CustomerID) AND convert(varchar,(ISNULL(EndSaleTime, StartSaleTime)),120)
						 < '''+convert(varchar, isnull(@Date,'1753-01-01'),120)+'''
						),0)'+@OnlyOpenSelect+ '
						as BeginBalance, BalanceDoe


			from customerview left outer join customeraddresses on customerview.customerid = customeraddresses.customerid
			and customeraddresses.status>-1 and  CustomerAddressID=''' +cast (@Ship as varchar(100))    +'''
			where 
			customerview.customerid='''+cast(@CustomerID as varchar(100)) + '''
			and customerview.status > -1 and customeraddresses.status>0
			and customerview.customerid = customeraddresses.customerid'
			

print (@MySelect+@Filter)
Execute (@MySelect+@Filter)
GO
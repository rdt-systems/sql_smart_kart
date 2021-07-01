SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SP_GetTransactionOneCustomer]
(@Filter nvarchar(4000),
 @CustomerID uniqueidentifier,
 @IsPOS  bit =1,
 @ShowDebitIsCredit  bit =1,
 @ShowOnlyOpenInvoices bit =0
 )
 AS

declare @MySelect2 nvarchar(4000)
declare @MySelect nvarchar(4000)



--===========================
--fix  temp for landau
--==========================
If (Select COUNT(*)  From SetUpValuesView Where OptionID = 91 AND (OptionValue ='1' OR OptionValue = 'True')) >0
Begin
SET @MySelect ='
SELECT    DISTINCT    (CASE WHEN t .TransactionType = 0 THEN (CASE WHEN T.PhoneOrder=1  THEN ''Phone Order'' ELSE ''Invoice'' END) WHEN t .TransactionType = 2 THEN ''Opening Balance'' WHEN t .TransactionType = 1 THEN ''Payment'' WHEN t .TransactionType
                          = 3 THEN ''Return'' WHEN t .TransactionType = 4 THEN ''Add Charge'' WHEN (t .TransactionType = 14 OR t .TransactionType = 15) THEN ''Layaway'' WHEN t .TransactionType = 16 THEN ''Close Layaway''   END) AS Type,  CONVERT(decimal(19, 2),  ISNULL(Payments.TotalAmount, ISNULL(T.Credit,0))) AS Paid, CONVERT(decimal(19, 2), T.Debit - T.Credit) AS Amount, T.Debit, 
                         T.Credit, dbo.FormatDateTime(T.EndSaleTime, ''HH:MM 12'') AS SaleTime, CONVERT(decimal(19, 2), T.CurrBalance) AS Balance, T.TransactionNo, T.StartSaleTime, 
                         T.DueDate, T.CustomerID, T.StartSaleTime AS DateT, T.TransactionID, T.Note, CustomerAddresses.Name AS [Shipping Name], ISNULL(CustomerAddresses.Street1, '''') 
                         + '' '' + ISNULL(CustomerAddresses.Street2, '''') AS ShipAddress, ISNULL(CustomerAddresses.City, '''') + '' '' + ISNULL(CustomerAddresses.State, '''') 
                         + '' '' + ISNULL(CustomerAddresses.Zip, '''') AS CSZ, ISNULL(L.AvailPoints, 0) AS [Avel Points], ISNULL(L.Points, 0) AS Points,IsNull(T.PhoneOrder,0) AS PO,Tender.Common1 AS Common,T.Tax
FROM            [Transaction] AS T LEFT OUTER JOIN
                             (SELECT DISTINCT Common1, TransactionID  FROM 
(SELECT ROW_NUMBER() OVER (PARTITION BY TransactionID 
      ORDER BY TransactionID ) AS DupeCount,Common1, TransactionID
  FROM TenderEntry Where Status>0 AND  (LEN(Common1) < 8)) AS f WHERE DupeCount = 1) AS Tender ON T.TransactionID = Tender.TransactionID LEFT OUTER JOIN
                              (SELECT        SUM(ISNULL(AvailPoints,0)) AS AvailPoints, CustomerID, SUM(ISNULL(Points,0)) AS Points, TransactionID
                               FROM            Loyalty where status>0 GROUP BY TransactionID, CustomerID) AS L ON T.TransactionID = L.TransactionID LEFT OUTER JOIN
                         CustomerAddresses ON T.ShipTo = CustomerAddresses.CustomerAddressID  LEFT OUTER JOIN
                             (SELECT        TransactionPayedID, SUM(ISNULL(Amount,0)) AS TotalAmount
                               FROM            PaymentDetails
                               WHERE        (Status > 0)
                               GROUP BY TransactionPayedID) AS Payments ON T.TransactionID = Payments.TransactionPayedID LEFT OUTER JOIN
                         Credit ON Credit.CreditID = T.TermsID AND Credit.Status > 0
WHERE     (T.Status > 0)   
'
if @ShowDebitIsCredit<> 1 
  SET @MySelect = @MySelect + ' AND T.Debit <> T.Credit'
  If @ShowOnlyOpenInvoices = 1 
	SET @MySelect = @MySelect + '  AND ((T.Debit - T.Credit) <> ISNULL(Payments.TotalAmount, 0)) AND ISNULL(t.leftdebit,0) > 0 '
  End
  Else Begin
  SET @MySelect ='
SELECT  DISTINCT    (CASE WHEN t .TransactionType = 0 THEN (CASE WHEN T.PhoneOrder=1  THEN ''Phone Order'' ELSE ''Invoice'' END) WHEN t .TransactionType = 2 THEN ''Opening Balance'' WHEN t .TransactionType = 1 THEN ''Payment'' WHEN t .TransactionType
                          = 3 THEN ''Return'' WHEN t .TransactionType = 4 THEN ''Add Charge''  WHEN (t .TransactionType = 14 OR t .TransactionType = 15) THEN ''Layaway'' END) AS Type,      CONVERT(decimal(19, 2),   ISNULL(Payments.TotalAmount, ISNULL(T.Credit,0)))  AS Paid, CONVERT(decimal(19, 2), T.Debit - T.Credit) AS Amount, T.Debit, 
                         T.Credit, dbo.FormatDateTime(T.EndSaleTime, ''HH:MM 12'') AS SaleTime, CONVERT(decimal(19, 2), T.CurrBalance) AS Balance, T.TransactionNo, T.StartSaleTime, 
                         T.DueDate, T.CustomerID, T.StartSaleTime AS DateT, T.TransactionID, T.Note, CustomerAddresses.Name AS [Shipping Name], ISNULL(CustomerAddresses.Street1, '''') 
                         + '' '' + ISNULL(CustomerAddresses.Street2, '''') AS ShipAddress, ISNULL(CustomerAddresses.City, '''') + '' '' + ISNULL(CustomerAddresses.State, '''') 
                         + '' '' + ISNULL(CustomerAddresses.Zip, '''') AS CSZ, ISNULL(L.AvailPoints, 0) AS [Avel Points], ISNULL(L.Points, 0) AS Points,IsNull(T.PhoneOrder,0) AS PO,T.Tax
FROM            [Transaction] AS T  LEFT OUTER JOIN
                              (SELECT        SUM(ISNULL(AvailPoints,0)) AS AvailPoints, CustomerID, SUM(ISNULL(Points,0)) AS Points, TransactionID
                               FROM            Loyalty where status>0 GROUP BY TransactionID, CustomerID) AS L ON T.TransactionID = L.TransactionID LEFT OUTER JOIN
                         CustomerAddresses ON T.ShipTo = CustomerAddresses.CustomerAddressID  LEFT OUTER JOIN
                             (SELECT        TransactionPayedID, SUM(Amount) AS TotalAmount
                               FROM            PaymentDetails
                               WHERE        (Status > 0)
                               GROUP BY TransactionPayedID) AS Payments ON T.TransactionID = Payments.TransactionPayedID LEFT OUTER JOIN
                         Credit ON Credit.CreditID = T.TermsID AND Credit.Status > 0
WHERE     (T.Status > 0) AND (T.StartSaleTime > =  dbo.GetCustomerDateStartBalance(T.CustomerID)) 
'
if @ShowDebitIsCredit<> 1 
  SET @MySelect = @MySelect + ' AND T.Debit <> T.Credit'
    If @ShowOnlyOpenInvoices = 1 
		SET @MySelect = @MySelect + '  AND ((T.Debit - T.Credit) <> ISNULL(Payments.TotalAmount, 0)) AND ISNULL(t.leftdebit,0) > 0 '
  End
--===========================
--end  fix  temp for landau
--==========================

set @MySelect2=
'SELECT DISTINCT  (CASE WHEN t .TransactionType = 0 THEN (CASE WHEN T.PhoneOrder=1  THEN ''Phone Order'' ELSE ''Invoice'' END) WHEN t .TransactionType = 2 THEN ''Opening Balance'' WHEN t .TransactionType = 1 THEN ''Payment'' WHEN t .TransactionType
                       = 3 THEN ''Return'' WHEN t .TransactionType = 4 THEN ''Add Charge'' END) AS Type, (CASE WHEN t .TransactionType = 0 THEN (CASE WHEN t .leftdebit = 0 OR
                      (t .leftdebit IS NULL AND t .debit > 0) THEN ''Unpaid'' WHEN t .leftdebit = t .debit OR
                      (t .leftdebit IS NULL AND t .debit < 0) THEN ''Paid'' WHEN t .debit - t .leftdebit > 0 THEN ''Partial'' END) ELSE NULL END) AS Paid, CONVERT(decimal(19, 2), 
                      t.Debit - t.Credit) AS Amount, t.Debit, t.Credit, t.EndTime AS SaleTime, CONVERT(decimal(19, 2), [Transaction].CurrBalance) AS Balance, t.TransactionNo, 
                      t.StartSaleTime, t.DueDate, t.CustomerID, t.StartSaleTime AS DateT, t.TransactionID, t.Note, ISNULL(Loyalty.Points, 0) AS Points, ISNULL(Loyalty.AvailPoints, 0) 
                      AS [Avel Points]
FROM         Loyalty RIGHT OUTER JOIN
                      TransactionWithPaidView AS t ON Loyalty.TransactionID = t.TransactionID RIGHT OUTER JOIN
                      [Transaction] ON t.TransactionID = [Transaction].TransactionID
WHERE     (t.Status > 0) AND (t.StartSaleTime >= dbo.GetCustomerDateStartBalance(t.CustomerID)) AND ([Transaction].Status > 0)'

print @MySelect+@Filter + ' order by DateT'
insert into sqlStatmentLog (sqlString) values(@MySelect+@Filter + ' order by DateT')
if @IsPos = 1
  execute(@MySelect+@Filter + ' order by DateT')
else 
  execute(@MySelect+@Filter + ' order by DateT')
GO
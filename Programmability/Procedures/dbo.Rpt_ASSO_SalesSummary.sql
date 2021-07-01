SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[Rpt_ASSO_SalesSummary]
(
@FromDate datetime,
@ToDate DateTime,
@StoreID uniqueidentifier = null
)

AS
if (Select Count(*) from Store where storeID in(
'CA74ACB2-9133-4F9F-A861-DCCA6047F9C1',
'B430448C-8460-4D80-8C8E-8C94DE606187',
'9FCE582C-DE75-4CF0-806B-DCFD49A4B8BA',
'F68AA66A-85F7-4E73-B709-EA2506B3A796',
'19F9C0E7-2283-45C9-8AB2-8B0D326765E3',
'C7B7BD0C-2850-4D39-B850-B75CC5B20F0C',
'3BADDE51-5BF8-4743-8BEF-95CD3C051DB6',
'123B8D63-0DB3-45C9-8208-0881E76F6679',
'F0CFBE28-5E83-4D0E-B818-141AFBDD93DD',
'11CBE062-8D0A-4B5C-B68D-AD6B82CA7095',
'35DB4D02-E89C-4F14-B254-7C7FE2FD0E51',
'2417C41A-3A08-408E-BD8C-A90CE607F49B',
'D70514DE-8B5F-4FC4-8FC6-69E3C46CEB7D',
'0FBC19FC-5788-4054-B210-900874A2D32D',
'9271610D-D169-43EC-BAD0-C5F7CC60038D',
'72D0868C-313C-4A4E-A6D4-A00EB65975FB',
'429A2984-3B51-4A50-9EE6-2370864C5534',
'946A9A6F-0FEB-454C-A7E0-33EE731A2E9D',
'7B5DB4EB-2674-4A5D-8EB5-9DCD63FECD81',
'F0AA5DED-0D4E-4CD2-A1FF-9DCF32C580DA',
'E6AA6776-1188-4243-BCA1-B675FC48237A',
'E3379EA6-5BF0-400E-B110-9AEF488BA4E7',
'E685D19D-883C-41F9-99F9-1C428D227126',
'1FAB2C02-1BE3-4A28-BE1B-5E4F9A8DE780'))>0
BEGIN

	SELECT        TransactionEntryItem.StartSaleTime AS Date, Users.UserName AS Assoc, TransactionEntryItem.BarcodeNumber AS SKU, TransactionEntryItem.Department, 
							 TransactionEntryItem.TransactionNo AS Tran#, TransactionEntryItem.Total AS Gross, TransactionEntryItem.Price, TransactionEntryItem.QTY, 
							 TransactionEntryItem.StoreName AS Store, TransactionEntryItem.TotalAfterDiscount AS Net, 
							 TransactionEntryItem.Total - TransactionEntryItem.TotalAfterDiscount AS Disc, TransactionEntryItem.Name AS [DESC], TransactionEntryItem.Brand, 
							 IsNull(Users.UserLName,'')+' '+IsNull(Users.UserFName,'') As AssocName,  Customer.FirstName, Customer.LastName, Customer.Email
	FROM            TransactionEntryItem INNER JOIN
							 Users ON TransactionEntryItem.UserID = Users.UserId INNER JOIN
							 [Transaction] ON TransactionEntryItem.TransactionID = [Transaction].TransactionID LEFT OUTER JOIN
							 Customer ON TransactionEntryItem.CustomerID = Customer.CustomerID
	WHERE        (dbo.GetDay(TransactionEntryItem.StartSaleTime) >= @FromDate) AND (dbo.GetDay(TransactionEntryItem.StartSaleTime) <= @ToDate)
	ORDER BY SKU 

END
ELSE BEGIN
	SELECT        SUM(TransactionEntryItem.TotalAfterDiscount) AS TotalSale, Users_2.UserName AS SaleAssociate, Users_2.UserId, Users_1.UserName AS Cashier, IsNull(Users_1.UserLName,'')+' '+IsNull(Users_1.UserFName,'') As CashierName,
							 dbo.GetDay(TransactionEntryItem.StartSaleTime) AS SaleDay, COUNT(DISTINCT[Transaction].TransactionID) AS TransQty, SUM(TransactionEntryItem.QTY) AS TotalQTY,
							 (SUM(TransactionEntryItem.QTY)/COUNT(DISTINCT[Transaction].TransactionID))As UPT,
							 ( SUM(TransactionEntryItem.TotalAfterDiscount)/COUNT(DISTINCT[Transaction].TransactionID))As ADS,IsNull(Users_2.UserLName,'')+' '+IsNull(Users_2.UserFName,'') As AssocName
	FROM            Users AS Users_2 INNER JOIN
							 SaleAssociate ON Users_2.UserId = SaleAssociate.UserID RIGHT OUTER JOIN
							 TransactionEntryItem INNER JOIN
							 [Transaction] ON TransactionEntryItem.TransactionID = [Transaction].TransactionID ON SaleAssociate.TransactionID = [Transaction].TransactionID LEFT OUTER JOIN Users AS Users_1
							 On [Transaction].UserCreated = Users_1.UserID
	WHERE        (dbo.GetDay([Transaction].StartSaleTime) >= @FromDate) AND (dbo.GetDay([Transaction].StartSaleTime) <= @ToDate) And (@StoreID Is Null or [Transaction].StoreID = @StoreID)

	GROUP BY Users_2.UserID, Users_2.UserName, dbo.GetDay(TransactionEntryItem.StartSaleTime),IsNull(Users_2.UserLName,'')+' '+IsNull(Users_2.UserFName,''), Users_1.UserName, IsNull(Users_1.UserLName,'')+' '+IsNull(Users_1.UserFName,'')
END
GO
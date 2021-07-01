SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[Rpt_ASSO_Sales](
@FromDate datetime,
@ToDate DateTime,
@UserID uniqueidentifier= null)
AS

IF @UserID IS NULL
BEGIN
	SELECT        TransactionEntryItem.StartSaleTime AS Date, Users.UserName AS Assoc, TransactionEntryItem.BarcodeNumber AS SKU, TransactionEntryItem.Department, 
							 TransactionEntryItem.TransactionNo AS Tran#, TransactionEntryItem.Total AS Gross, TransactionEntryItem.Price, TransactionEntryItem.QTY, 
							 TransactionEntryItem.StoreName AS Store, TransactionEntryItem.TotalAfterDiscount AS Net, 
							 TransactionEntryItem.Total - TransactionEntryItem.TotalAfterDiscount AS Disc, TransactionEntryItem.Name AS [DESC], TransactionEntryItem.Brand, 
							 ItemSerialEntry.SerialNumber1, ItemSerialEntry.SerialNumber2, ItemSerialEntry.SerialNumber3, ItemSerialEntry.SerialNumber4, ItemSerialEntry.SerialNumber5, 
							 Users_2.UserName AS SaleAssociate
	FROM            Users AS Users_2 INNER JOIN
							 SaleAssociate ON Users_2.UserId = SaleAssociate.UserID RIGHT OUTER JOIN
							 TransactionEntryItem INNER JOIN
							 Users ON TransactionEntryItem.UserID = Users.UserId INNER JOIN
							 [Transaction] ON TransactionEntryItem.TransactionID = [Transaction].TransactionID ON SaleAssociate.TransactionID = [Transaction].TransactionID LEFT OUTER JOIN
							 ItemSerialEntry ON TransactionEntryItem.TransactionEntryID = ItemSerialEntry.TransEntryID
	WHERE        (dbo.GetDay(TransactionEntryItem.StartSaleTime) >= @FromDate) AND (dbo.GetDay(TransactionEntryItem.StartSaleTime) <= @ToDate)
	ORDER BY Store, Assoc
END
ELSE
BEGIN
	SELECT        TransactionEntryItem.StartSaleTime AS Date, Users.UserName AS Assoc, TransactionEntryItem.BarcodeNumber AS SKU, TransactionEntryItem.Department, 
							 TransactionEntryItem.TransactionNo AS Tran#,TransactionEntryItem.TransactionID, TransactionEntryItem.Total AS Gross, TransactionEntryItem.Price, TransactionEntryItem.QTY, 
							 TransactionEntryItem.StoreName AS Store, TransactionEntryItem.TotalAfterDiscount AS Net, 
							 TransactionEntryItem.Total - TransactionEntryItem.TotalAfterDiscount AS Disc, TransactionEntryItem.Name AS [DESC], TransactionEntryItem.Brand, 
							 ItemSerialEntry.SerialNumber1, ItemSerialEntry.SerialNumber2, ItemSerialEntry.SerialNumber3, ItemSerialEntry.SerialNumber4, ItemSerialEntry.SerialNumber5, 
							 Users_2.UserName AS SaleAssociate
	FROM            Users AS Users_2 INNER JOIN
							 SaleAssociate ON Users_2.UserId = SaleAssociate.UserID RIGHT OUTER JOIN
							 TransactionEntryItem INNER JOIN
							 Users ON TransactionEntryItem.UserID = Users.UserId INNER JOIN
							 [Transaction] ON TransactionEntryItem.TransactionID = [Transaction].TransactionID ON SaleAssociate.TransactionID = [Transaction].TransactionID LEFT OUTER JOIN
							 ItemSerialEntry ON TransactionEntryItem.TransactionEntryID = ItemSerialEntry.TransEntryID
	WHERE        (dbo.GetDay(TransactionEntryItem.StartSaleTime) >= @FromDate) AND (dbo.GetDay(TransactionEntryItem.StartSaleTime) <= @ToDate)AND (SaleAssociate.UserID =@UserID)
END
GO
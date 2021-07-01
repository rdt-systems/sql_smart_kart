SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SP_InsertSendSaleTexts]
AS

Insert Into Emails (EmailID, Body, FromAddress, ToAddress, MailType, EmailUid, Status, DateCreated)
Select RE.RequestTransferEntryID,'Your item is on the way, let the adventure begin! As soon as your ' + P.Name +' ' + M.Matrix1 + ' in size '+M.Matrix2+'  (X' +  CONVERT(nvarchar(5),RE.Qty) +') arrive to our store, we will be in touch.
www.pastelcollections.com ' ,
'12035298471',
'1' + Replace(Replace(Replace(A.PhoneNumber2,'(',''),')',''),'-',''),
2,
R.RequestNo,
1,
dbo.GetLocalDate()
from dbo.[Transaction] T WITH (NOLOCK) INNER JOIN 
dbo.TransactionEntry E  WITH (NOLOCK)
ON T.TransactionID = E.TransactionID INNER JOIN 
dbo.RequestTransferEntry RE  WITH (NOLOCK) 
ON E.TransactionEntryID = RE.TransactionEntryID AND E.TransactionEntryType = 11 AND E.Status > 0 INNER JOIN 
dbo.RequestTransfer R WITH (NOLOCK)  
ON RE.RequestTransferID = R.RequestTransferID INNER JOIN 
dbo.Customer C WITH (NOLOCK)  
ON RE.CustomerId = C.CustomerID
INNER JOIN dbo.CustomerAddresses A WITH (NOLOCK)  
ON C.CustomerID = A.CustomerID AND C.MainAddressID = A.CustomerAddressID AND A.AddressType = 6 AND LEN(ISNULL(A.PhoneNumber2,'')) > =10
INNER JOIN dbo.ItemStore S WITH (NOLOCK)  
ON RE.ItemStoreID = S.ItemStoreID INNER JOIN 
dbo.ItemMain M WITH (NOLOCK) ON S.ItemNo = M.ItemID INNER JOIN 
dbo.ItemMain P WITH (NOLOCK) ON M.LinkNo = P.ItemID
Where T.Status > 0 AND E.Status > 0 AND RE.Status >0 AND R.Status >0 AND ISNULL(R.RequestStatus,0) <2 
AND RE.RequestTransferEntryID NOT IN (Select RequestTransferEntryID From TransferEntry Where Status > 0 AND RequestTransferEntryID IS NOT NULL) AND RE.RequestTransferEntryID NOT IN (Select EmailID From Emails)

--Insert Into Emails (EmailID, Body, FromAddress, ToAddress, MailType, EmailUid, Status, DateCreated)
--Select ER.TransferEntryID ,'Thanks For Choosing '+Store.StoreName +',  Your Order #' + T.TransactionNo + ' For '+ M.Name + ' ('+ CONVERT(nvarchar(5),ER.Qty) + ') you requested has been Sent successfully! You will receive another text once it is received in the Store.' ,
--'12035298471',
--'1' + Replace(Replace(Replace(A.PhoneNumber2,'(',''),')',''),'-',''),
--2,
--R.RequestNo,
--1,
--dbo.GetLocalDate()
--from [Transaction] T INNER JOIN TransactionEntry E ON T.TransactionID = E.TransactionID INNER JOIN RequestTransferEntry RE ON E.TransactionEntryID = RE.TransactionEntryID AND E.TransactionEntryType = 11 AND E.Status > 0 
--INNER JOIN RequestTransfer R ON RE.RequestTransferID = R.RequestTransferID INNER JOIN TransferEntry ER ON RE.RequestTransferEntryID = ER.RequestTransferEntryID INNER JOIN TransferItems I ON ER.TransferID = I.TransferID 
--INNER JOIN Customer C ON RE.CustomerId = C.CustomerID
--INNER JOIN CustomerAddresses A ON C.CustomerID = A.CustomerID AND C.MainAddressID = A.CustomerAddressID AND A.AddressType = 6 AND LEN(ISNULL(A.PhoneNumber2,'')) > =10
--INNER JOIN ItemStore S ON RE.ItemStoreID = S.ItemStoreID INNER JOIN ItemMain M ON S.ItemNo = M.ItemID INNER JOIN Store ON R.ToStoreID = Store.StoreID
--Where T.Status > 0 AND E.Status > 0 AND RE.Status >0 AND R.Status >0 AND ER.Status > 0 AND I.Status > 0  AND ISNULL(I.TransferStatus,0) <3
--AND  ER.TransferEntryID NOT IN (Select TransferEntryID From ReceiveTransferEntry Where Status > 0 AND TransferEntryID IS NOT NULL) AND ER.TransferEntryID NOT IN (Select EmailID From Emails)

Insert Into Emails (EmailID, Body, FromAddress, ToAddress, MailType, EmailUid, Status, DateCreated)
Select RT.ReceiveTranferEntryID ,'Time to add room in your closet, your items have arrived! Your ' + P.Name +' ' + M.Matrix1 + ' in size '+M.Matrix2+'  (X' +  CONVERT(nvarchar(5),RE.Qty) +') is ready to be picked up from our '+ SUBSTRING(StoreName,CHARINDEX('-',StoreName)+1,LEN(StoreName))+' location. We can''t wait to see your little one looking sharp in Pastel!
www.pastelcollections.com' ,
'12035298471',
'1' + Replace(Replace(Replace(A.PhoneNumber2,'(',''),')',''),'-',''),
2,
R.RequestNo,
1,
dbo.GetLocalDate()
from dbo.[Transaction] T WITH (NOLOCK) INNER JOIN 
dbo.TransactionEntry E  WITH (NOLOCK) 
ON T.TransactionID = E.TransactionID INNER JOIN 
dbo.RequestTransferEntry RE ON E.TransactionEntryID = RE.TransactionEntryID AND E.TransactionEntryType = 11 AND E.Status > 0 
INNER JOIN 
dbo.RequestTransfer R  WITH (NOLOCK) 
ON RE.RequestTransferID = R.RequestTransferID INNER JOIN 
dbo.TransferEntry ER  WITH (NOLOCK) 
ON RE.RequestTransferEntryID = ER.RequestTransferEntryID INNER JOIN 
dbo.TransferItems I WITH (NOLOCK)  ON ER.TransferID = I.TransferID
INNER JOIN 
dbo.ReceiveTransferEntry RT WITH (NOLOCK)  ON ER.TransferEntryID = RT.TransferEntryID INNER JOIN 
dbo.ReceiveTransfer RR WITH (NOLOCK)  ON RT.ReceiveTransferID = RR.ReceiveTransferID
INNER JOIN dbo.Customer C WITH (NOLOCK)  ON RE.CustomerId = C.CustomerID
INNER JOIN dbo.CustomerAddresses A WITH (NOLOCK)  ON C.CustomerID = A.CustomerID AND C.MainAddressID = A.CustomerAddressID AND A.AddressType = 6 AND LEN(ISNULL(A.PhoneNumber2,'')) > =10
INNER JOIN dbo.ItemStore S WITH (NOLOCK)  ON RE.ItemStoreID = S.ItemStoreID INNER JOIN 
dbo.ItemMain M WITH (NOLOCK)  ON S.ItemNo = M.ItemID INNER JOIN 
dbo.ItemMain P WITH (NOLOCK) ON M.LinkNo = P.ItemID INNER JOIN Store ON R.ToStoreID = Store.StoreID
Where T.Status > 0 AND E.Status > 0 AND RE.Status >0 AND R.Status >0 AND ER.Status > 0 AND I.Status > 0 AND RT.Status > 0 and RR.Status > 0
AND  RT.ReceiveTranferEntryID NOT IN (Select EmailID From Emails)
GO
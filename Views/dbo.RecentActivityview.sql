SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO

CREATE VIEW [dbo].[RecentActivityview] AS 

--merge customer  
SELECT  DISTINCT CONVERT(VARCHAR(MAX),[RecentActivityId])AS [RecentActivityId]
      ,[ActivityType],
	  SystemValues.systemvalueName
 ,'<b'+ISNULL(LTRIM(ISNULL(users.UserFName,'')+' '+ISNULL(users.UserLName,'')),users.UserName)+'  b>'+ SystemValues.systemvalueName +' <b'+ ISNULL([RecentActivity].AdditionalInfo,'') +'b> to <b' +ISNULL(customer.CustomerNo,'') +' '+ISNULL(customer.FirstName,'') +' '+ISNULL(customer.LastName,'')+'b>'AS Action,
	  [RecentActivity].DateModified,
	 [RecentActivity].TableID,
	  [RecentActivity].TableName,
	  users.UserName,SystemValues.SystemTableNo, 
	  NULL AS StoreId 
  FROM [dbo].[RecentActivity] JOIN customer ON customer.CustomerID =[RecentActivity].TableID AND [RecentActivity].TableName ='Customer' AND [RecentActivity].fieldName='CustomerID'
  JOIN SystemValues ON SystemValues.systemvalueno=[RecentActivity].[ActivityType] AND SystemValues.SystemTableNo=57 AND [RecentActivity].[ActivityType] =1 
  LEFT OUTER JOIN users ON users.UserId=[RecentActivity].UserId

   UNION ALL
  --add customer 
  SELECT  DISTINCT CONVERT(VARCHAR(MAX),[RecentActivityId])
      ,[ActivityType],
	  SystemValues.systemvalueName
 ,'<b'+ISNULL(LTRIM(ISNULL(users.UserFName,'')+' '+ISNULL(users.UserLName,'')),users.UserName)+'  b>'+ SystemValues.systemvalueName +' <b'+ISNULL(customer.CustomerNo,'') +' '+ISNULL(customer.FirstName,'') +' '+ISNULL(customer.LastName,'')+'b>'  AS action,
	  [RecentActivity].DateModified,
	  	 [RecentActivity].TableID,
	  [RecentActivity].TableName,
	  users.UserName,SystemValues.SystemTableNo, 
	  NULL AS StoreId 
  FROM [dbo].[RecentActivity] JOIN customer ON customer.CustomerID =[RecentActivity].TableID AND [RecentActivity].TableName ='Customer' AND [RecentActivity].fieldName='CustomerID'
  JOIN SystemValues ON SystemValues.systemvalueno=[RecentActivity].[ActivityType] AND SystemValues.SystemTableNo=57 AND [RecentActivity].[ActivityType] =2
    LEFT OUTER JOIN users ON users.UserId=[RecentActivity].UserId
   UNION ALL
  
  --add item 
  SELECT  DISTINCT CONVERT(VARCHAR(MAX),[RecentActivityId])
      ,[ActivityType],
	  SystemValues.systemvalueName
 ,'<b'+ISNULL(LTRIM(ISNULL(users.UserFName,'')+' '+ISNULL(users.UserLName,'')),users.UserName)+'  b>'+ SystemValues.systemvalueName +' <b'+ ISNULL(itemMain.BarcodeNumber,'') +' '+ISNULL(itemMain.Name,'')+'b>' AS action,
	  [RecentActivity].DateModified,
	  	 [RecentActivity].TableID,
	  [RecentActivity].TableName,
	  users.UserName,SystemValues.SystemTableNo, 
	  NULL AS StoreId 
  FROM [dbo].[RecentActivity] JOIN itemMain ON itemMain.Itemid =[RecentActivity].TableID AND [RecentActivity].TableName ='itemMain' AND [RecentActivity].fieldName='ItemID'
  JOIN SystemValues ON SystemValues.systemvalueno=[RecentActivity].[ActivityType] AND SystemValues.SystemTableNo=57 AND [RecentActivity].[ActivityType] =3
    LEFT OUTER JOIN users ON users.UserId=[RecentActivity].UserId
   UNION ALL

 --   --merge item 
 -- SELECT  DISTINCT CONVERT(VARCHAR(MAX),[RecentActivityId])
 --     ,[ActivityType],
	--  SystemValues.systemvalueName
 --,SystemValues.systemvalueName + ' ' +ISNULL([RecentActivity].AdditionalInfo,'') +' to '+ISNULL(itemMain.BarcodeNumber,'') +' '+ISNULL(itemMain.Name,'') AS action,
	--  [RecentActivity].DateModified,
	--  	 [RecentActivity].TableID,
	--  [RecentActivity].TableName,
	--  users.UserName,SystemValues.SystemTableNo, 
	--  NULL AS StoreId 
 -- FROM [dbo].[RecentActivity] JOIN itemMain ON itemMain.Itemid =[RecentActivity].TableID AND [RecentActivity].TableName ='itemMain' AND [RecentActivity].fieldName='ItemID'
 -- JOIN SystemValues ON SystemValues.systemvalueno=[RecentActivity].[ActivityType] AND SystemValues.SystemTableNo=57 AND [RecentActivity].[ActivityType] =4
 --   LEFT OUTER JOIN users ON users.UserId=[RecentActivity].UserId
  --UNION ALL

--change credit line 
SELECT CONVERT(VARCHAR(MAX),CustomerActivatyID)
      ,5 AS [ActivityType],
	  SystemValues.systemvalueName
 , '<b'+ISNULL(LTRIM(ISNULL(users.UserFName,'')+' '+ISNULL(users.UserLName,'')),users.UserName)+'  b>'+'updated customer <b '+ISNULL(customer.CustomerNo,'') +' '+ISNULL(customer.FirstName,'') +' '+ISNULL(customer.LastName,'')+ 
 'b> credit From <b'+ CONVERT(VARCHAR(MAX),[CustomerActivaty].OldCreditLine) +'b> to <b'+ CONVERT(VARCHAR(MAX),NewCreditLine)+'b>'   AS action,
	  [CustomerActivaty].DateModified,
	  	[CustomerActivaty].CustomerID,
	  'customer' AS TableName,
	  users.UserName,SystemValues.SystemTableNo, 
	  NULL AS StoreId 
  FROM [dbo].[CustomerActivaty] JOIN customer ON [CustomerActivaty].CustomerID=customer.CustomerID 
  JOIN SystemValues ON SystemValues.systemvalueno=5 AND SystemValues.SystemTableNo=57 
    LEFT OUTER JOIN users ON users.UserId=[CustomerActivaty].UserCreated

   UNION ALL

      --Adjust Inventory
  SELECT  DISTINCT CONVERT(VARCHAR(MAX),[AdjustInventoryId])
      ,SystemValues.systemvalueno,
	  SystemValues.systemvalueName
 ,'<b'+ISNULL(LTRIM(ISNULL(users.UserFName,'')+' '+ISNULL(users.UserLName,'')),users.UserName)+'  b>'+SystemValues.systemvalueName +' item <b #' +ISNULL(itemMain.BarcodeNumber,'') +' '+ISNULL(itemMain.Name,'')+'b> from <b'+CONVERT(VARCHAR(MAX),[AdjustInventory].OldQty)+'b> to <b'+CONVERT(VARCHAR(MAX),[AdjustInventory].Qty)+'b>' AS action,
	  [AdjustInventory].DateModified,
	  	ItemStore.ItemStoreID,
	  'ItemStore' AS TableName,
	  users.UserName,SystemValues.SystemTableNo, 
	  ItemStore.StoreNo AS StoreId 
  FROM [dbo].[AdjustInventory] JOIN ItemStore ON ItemStore.ItemStoreID=[AdjustInventory].ItemStoreNo JOIN itemMain ON itemMain.Itemid =ItemStore.ItemNo
  JOIN SystemValues ON SystemValues.systemvalueno=6 AND SystemValues.SystemTableNo=57
    LEFT OUTER JOIN users ON users.UserId=[AdjustInventory].UserCreated

	--   UNION ALL

 --       --PriceChange
 -- SELECT  DISTINCT CONVERT(VARCHAR(MAX),[PriceChangeHistoryID])
 --     ,SystemValues.systemvalueno,
	--  SystemValues.systemvalueName
 --,SystemValues.systemvalueName +' Of ' +ISNULL(itemMain.BarcodeNumber,'') +' '+ISNULL(itemMain.Name,'')+' From '+CONVERT(VARCHAR(MAX),PriceChangeHistory.OldPrice)+' to '+CONVERT(VARCHAR(MAX),PriceChangeHistory.NewPrice) AS action,
	--  PriceChangeHistory.Date,
	--  	ItemStore.ItemStoreID,
	--  'ItemStore' AS TableName,
	--  users.UserName,SystemValues.SystemTableNo,
	--  ItemStore.StoreNo AS StoreId 
 -- FROM [dbo].PriceChangeHistory JOIN ItemStore ON ItemStore.ItemStoreID=PriceChangeHistory.ItemStoreID JOIN itemMain ON itemMain.Itemid =ItemStore.ItemNo
 -- JOIN SystemValues ON SystemValues.systemvalueno=7 AND SystemValues.SystemTableNo=57
 --   LEFT OUTER JOIN users ON users.UserId=PriceChangeHistory.UserId
	--WHERE PriceChangeHistory.PriceLevel='Price'

	
	--   UNION ALL

 --       --CostChange
 -- SELECT  DISTINCT CONVERT(VARCHAR(MAX),[PriceChangeHistoryID])
 --     ,SystemValues.systemvalueno,
	--  SystemValues.systemvalueName
 --,SystemValues.systemvalueName +' Of ' +ISNULL(itemMain.BarcodeNumber,'') +' '+ISNULL(itemMain.Name,'')+' From '+CONVERT(VARCHAR(MAX),PriceChangeHistory.OldPrice)+' to '+CONVERT(VARCHAR(MAX),PriceChangeHistory.NewPrice) AS action,
	--  PriceChangeHistory.Date,
	--  	ItemStore.ItemStoreID,
	--  'ItemStore' AS TableName,
	--  users.UserName,SystemValues.SystemTableNo,
	--  ItemStore.StoreNo AS StoreId 
 -- FROM [dbo].PriceChangeHistory JOIN ItemStore ON ItemStore.ItemStoreID=PriceChangeHistory.ItemStoreID JOIN itemMain ON itemMain.Itemid =ItemStore.ItemNo
 -- JOIN SystemValues ON SystemValues.systemvalueno=8 AND SystemValues.SystemTableNo=57
 --   LEFT OUTER JOIN users ON users.UserId=PriceChangeHistory.UserId
	--WHERE PriceChangeHistory.PriceLevel='Cost'


		   UNION ALL
  --Actions

	SELECT  DISTINCT CONVERT(VARCHAR(MAX),ActionID)
      ,SystemValues.systemvalueno,
	  SystemValues.systemvalueName,
  '<b'+ISNULL(LTRIM(ISNULL(users.UserFName,'')+' '+ISNULL(users.UserLName,'')),users.UserName)+'b>'+'  ' 
  +
 CASE 
 WHEN SystemValues.SystemValueNo=1
 THEN 'canceled sale <b#'+ISNULL([transaction].TransactionNo,'') +'b> , <b'+ FORMAT(ISNULL([dbo].Actions.ActionSum,'0'),'C2')+'b>'+' in register <b#'+ISNULL(RegisterNo,'')+'b>' 

 WHEN SystemValues.SystemValueNo=2
 THEN 'voided item <b'+ISNULL(Info,'') +'b> '

 WHEN SystemValues.SystemValueNo=3
 THEN 'opened drawer on register <b#'+dbo.Registers.RegisterNo  +'b>'

 WHEN SystemValues.SystemValueNo=4 
 THEN 'closed register <b#'+ISNULL(dbo.Registers.RegisterNo,'') +'b>'

 WHEN SystemValues.SystemValueNo=5
  THEN 'discounted <b'+FORMAT(ISNULL(Actions.ActionSum,0),'C2') + 'b> from <b#'+ISNULL([transaction].TransactionNo,'') +'b>,<b'+ISNULL(FORMAT([dbo].[Transaction].Debit,'C2') ,'')+'b>'


WHEN SystemValues.SystemValueNo=6
THEN 'changed price '+ISNULL(actions.Info ,'')


WHEN SystemValues.SystemValueNo=7
THEN 'returend item '+ISNULL(actions.Info ,'')


WHEN SystemValues.SystemValueNo=8
THEN 'updated customer <b'+ISNULL(dbo.Customer.CustomerNo,'')+' ,' +ISNULL(dbo.Customer.FirstName,'') +ISNULL(dbo.Customer.LastName,'')+'b> credit  to<b' +FORMAT(ISNULL([dbo].Actions.ActionSum,0),'C2')+'b>'

WHEN SystemValues.SystemValueNo=9
THEN 'cahed check for <b'+FORMAT([dbo].Actions.ActionSum,'C2') +'b>'


WHEN SystemValues.SystemValueNo=11
THEN 'updated customer <b'+ISNULL(dbo.Customer.CustomerNo,'')+' ,' +ISNULL(dbo.Customer.FirstName,'') +ISNULL(dbo.Customer.LastName,'')+'b> info '

WHEN SystemValues.SystemValueNo=12
THEN 'suspended sale  <b#'+ISNULL([transaction].TransactionNo,'')+' ,'+ISNULL(FORMAT([dbo].[Transaction].Debit,'C2') ,'')+' ,'+ISNULL([transaction].Note,0)+'b>'

WHEN SystemValues.SystemValueNo=13
THEN 'updated qty of item  <b#'+ISNULL(actions.Info ,'')


WHEN SystemValues.SystemValueNo=15
THEN 'closed-out register <b#'+dbo.Registers.RegisterNo  +'b>'


WHEN SystemValues.SystemValueNo=16
THEN 'exempt sales tax on sale <b#'+ISNULL([transaction].TransactionNo,'') +'b> , <b'+ ISNULL(FORMAT([dbo].[Transaction].Debit,'C2') ,'')+'b>' +' in register <b'+Registers.RegisterNo  +'b>'+' for <b'+ISNULL(dbo.Customer.CustomerNo,'')+' ,' +ISNULL(dbo.Customer.FirstName,'') +ISNULL(dbo.Customer.LastName,'')+'b>'


WHEN SystemValues.SystemValueNo=17
THEN ' paid on account <b#'+ISNULL([transaction].TransactionNo,'') +'b>, <b '+ISNULL(dbo.Customer.CustomerNo,'')+' ,' +ISNULL(dbo.Customer.FirstName,'') +ISNULL(dbo.Customer.LastName,'') +' '+FORMAT([dbo].Actions.ActionSum,'C2') +'b>'
 
WHEN SystemValues.SystemValueNo=18
THEN 'sold gift card <b'+ISNULL([transaction].TransactionNo,'') +'b> Of <b'+ FORMAT(ISNULL([dbo].Actions.ActionSum,0),'C2')+ 'b> to <b'+ISNULL(dbo.Customer.CustomerNo,'')+' ,' +ISNULL(dbo.Customer.FirstName,'') +
ISNULL(dbo.Customer.LastName,'')+' b>'

WHEN SystemValues.SystemValueNo=19
THEN 'paid sale <b'+ISNULL([transaction].TransactionNo,'') +' , '+ FORMAT([dbo].Actions.ActionSum,'C2')+ ' offline'+' b>'
 
WHEN SystemValues.SystemValueNo=22
THEN 'added manual Item <b'+ISNULL([transaction].TransactionNo,'') +' Of '+ FORMAT([dbo].Actions.ActionSum,'C2') +'b>'


 ELSE SystemValues.systemvalueName + 
 CASE  WHEN [transaction].TransactionNo IS NOT NULL THEN ' of transaction ' +'<b'+	ISNULL([transaction].TransactionNo,'')+'b>' ELSE '' END END  AS action,
	  Actions.ActionDate,
	  	[transaction].TransactionID,
	  'transaction' AS TableName,
	  users.UserName,SystemValues.SystemTableNo,
	  [transaction].StoreID AS StoreId 
  FROM [dbo].Actions LEFT JOIN [transaction] ON [transaction].TransactionID=Actions.TransactionID 
  JOIN SystemValues ON SystemValues.systemvalueno=Actions.actionType AND SystemValues.SystemTableNo=27
  LEFT OUTER JOIN  dbo.Registers ON Registers.RegisterID = Actions.RegisterID
    LEFT OUTER JOIN users ON users.UserId=Actions.UserId
	LEFT OUTER JOIN dbo.Customer ON Customer.CustomerID = [Transaction].CustomerID
	WHERE Actions.ActionType NOT IN (10,14,13) 

	
		   UNION ALL 

		  ---payout
	
	SELECT  DISTINCT CONVERT(VARCHAR(MAX),ActionID)
      ,SystemValues.systemvalueno,
	  SystemValues.systemvalueName,
	 
  '<b'+ISNULL(LTRIM(ISNULL(users.UserFName,'')+' '+ISNULL(users.UserLName,'')),users.UserName)+' b>'+' ' 
 +
 CASE 
 
 WHEN SystemValues.SystemValueNo=10
 THEN 'made a <b'+ FORMAT( PayOut.Amount,'C2')+'b> payout to <b' +ISNULL(PayOut.Reason,'') +'b> from  register <b'+Registers.RegisterNo+'b>' END  AS action,
	  Actions.ActionDate,
	  	PayOut.PayOutID,
	  'transaction' AS TableName,
	  users.UserName,SystemValues.SystemTableNo,
	  Batch.StoreID AS StoreId 
  FROM [dbo].Actions  JOIN dbo.PayOut ON PayOut.PayOutID=Actions.TransactionID 
  JOIN Batch ON Batch.BatchID = PayOut.BatchID
  JOIN SystemValues ON SystemValues.systemvalueno=Actions.actionType AND SystemValues.SystemTableNo=27
  LEFT OUTER JOIN  dbo.Registers ON Registers.RegisterID = Actions.RegisterID
    LEFT OUTER JOIN users ON users.UserId=Actions.UserId
	WHERE ActionType=10


	 --Actions




	   UNION ALL

    --Discounts
  SELECT  DISTINCT CONVERT(VARCHAR(MAX),[RecentActivityId])
      ,[ActivityType],
	  SystemValues.systemvalueName
 ,'<b'+ISNULL(LTRIM(ISNULL(users.UserFName,'')+' '+ISNULL(users.UserLName,'')),users.UserName)+'  b>'+SystemValues.systemvalueName + ' <b'+ISNULL(Discounts.Name,'')+' '+CASE WHEN discounts.PercentsDiscount IS NOT NULL THEN FORMAT(discounts.PercentsDiscount,'P') ELSE FORMAT(discounts.AmountDiscount,'C2') END +' b>'AS action,
	  [RecentActivity].DateModified,
	  	 [RecentActivity].TableID,
	  [RecentActivity].TableName,
	  users.UserName,SystemValues.SystemTableNo,
	  NULL AS StoreId 
  FROM [dbo].[RecentActivity] JOIN Discounts ON Discounts.DiscountID =[RecentActivity].TableID AND [RecentActivity].TableName ='Discounts' AND [RecentActivity].fieldName='DiscountID'
  JOIN SystemValues ON SystemValues.systemvalueno=[RecentActivity].[ActivityType] AND SystemValues.SystemTableNo=57 AND [RecentActivity].[ActivityType] IN (9,10,11,12)
    LEFT OUTER JOIN users ON users.UserId=[RecentActivity].UserId


		   UNION ALL

    --PurchaseOrder
  SELECT  DISTINCT CONVERT(VARCHAR(MAX),[RecentActivityId])
      ,[ActivityType],
	  SystemValues.systemvalueName
 ,'<b'+ISNULL(LTRIM(ISNULL(users.UserFName,'')+' '+ISNULL(users.UserLName,'')),users.UserName)+'  b>'+SystemValues.systemvalueName + ' <b '+ISNULL(PurchaseOrders.PoNo,'')+' ' + ISNULL(FORMAT(PurchaseOrders.GrandTotal,'C2') ,'') +' for <b'+dbo.Supplier.Name+'b>'  AS action,
	  [RecentActivity].DateModified,
	  	 [RecentActivity].TableID,
	  [RecentActivity].TableName,
	  users.UserName,SystemValues.SystemTableNo,
	  PurchaseOrders.StoreNo AS StoreId 
  FROM [dbo].[RecentActivity] JOIN PurchaseOrders ON PurchaseOrders.PurchaseOrderId =[RecentActivity].TableID AND [RecentActivity].TableName ='PurchaseOrders' AND [RecentActivity].fieldName='PurchaseOrderId'
  JOIN SystemValues ON SystemValues.systemvalueno=[RecentActivity].[ActivityType] AND SystemValues.SystemTableNo=57 AND [RecentActivity].[ActivityType] IN (13,14,15,16)
  JOIN dbo.Supplier ON Supplier.SupplierID = PurchaseOrders.SupplierNo
    LEFT OUTER JOIN users ON users.UserId=[RecentActivity].UserId
	

	
		   UNION ALL

    --receiveOrder
  SELECT  DISTINCT CONVERT(VARCHAR(MAX),[RecentActivityId])
      ,[ActivityType],
	  SystemValues.systemvalueName
 ,'<b'+ISNULL(LTRIM(ISNULL(users.UserFName,'')+' '+ISNULL(users.UserLName,'')),users.UserName)+'  b>'+SystemValues.systemvalueName + ' <b '+ISNULL(bill.BillNo,'')+' ' + ISNULL(FORMAT(receiveOrder.Total,'C2') ,'') +' for <b'+dbo.Supplier.Name+'b>'  AS action,
	  [RecentActivity].DateModified,
	  	 [RecentActivity].TableID,
	  [RecentActivity].TableName,
	  users.UserName,SystemValues.SystemTableNo,
	  	  receiveOrder.StoreID AS StoreId 
  FROM [dbo].[RecentActivity] JOIN receiveOrder ON receiveOrder.ReceiveID =[RecentActivity].TableID AND [RecentActivity].TableName ='receiveOrder' AND [RecentActivity].fieldName='ReceiveID'
  JOIN bill ON bill.BillID=receiveOrder.BillID
  JOIN SystemValues ON SystemValues.systemvalueno=[RecentActivity].[ActivityType] AND SystemValues.SystemTableNo=57 AND [RecentActivity].[ActivityType] IN (17,18,19,20)
   JOIN dbo.Supplier ON Supplier.SupplierID = receiveOrder.SupplierNo
    LEFT OUTER JOIN users ON users.UserId=[RecentActivity].UserId

		   UNION ALL

    --Transaction
  SELECT  DISTINCT CONVERT(VARCHAR(MAX),[RecentActivityId])
      ,[ActivityType],
	  SystemValues.systemvalueName
 ,'<b'+ISNULL(ISNULL(LTRIM(users.UserFName+' '+users.UserLName),users.UserName),'')+' b>'+ ' completed sale <b#' +ISNULL([Transaction].TransactionNo,'') +'b> , <b'+FORMAT([transaction].Debit,'C2')+'b>'+' in Register <b'+ISNULL(dbo.Registers.RegisterNo,'')+' b>'
 AS action
 ,
	  [RecentActivity].DateModified,
	  	 [RecentActivity].TableID,
	  [RecentActivity].TableName,
	  users.UserName,SystemValues.SystemTableNo,
	    [Transaction].StoreID AS StoreId 
  FROM [dbo].[RecentActivity] JOIN [Transaction] ON [Transaction].TransactionID =[RecentActivity].TableID AND [RecentActivity].TableName ='Transaction' AND [RecentActivity].fieldName='TransactionID'
  
  JOIN SystemValues ON SystemValues.systemvalueno=[RecentActivity].[ActivityType] AND SystemValues.SystemTableNo=57 AND [RecentActivity].[ActivityType] IN (21,22,23,24)
  LEFT OUTER JOIN	 dbo.Registers ON Registers.RegisterID = [Transaction].RegisterID
    LEFT OUTER JOIN users ON users.UserId=[RecentActivity].UserId
	
	WHERE (([RecentActivity].[ActivityType] =21 AND [Transaction].Status=1 )OR [RecentActivity].[ActivityType] !=21)


			   UNION ALL

    --Users
  SELECT  DISTINCT CONVERT(VARCHAR(MAX),[RecentActivityId])
      ,[ActivityType],
	  SystemValues.systemvalueName
 ,'<b'+ISNULL(LTRIM(ISNULL(users.UserFName,'')+' '+ISNULL(users.UserLName,'')),users.UserName)+'  b>'
 
 +SystemValues.systemvalueName + ' <b '+ISNULL(UserE.UserFName,'') +ISNULL(UserE.UserLName,'')+'b> in group ' + ISNULL(groups.GroupName,'')   AS action,
	  [RecentActivity].DateModified,
	  	 [RecentActivity].TableID,
	  [RecentActivity].TableName,
	  users.UserName,SystemValues.SystemTableNo,
	  	  NULL AS StoreId 
  FROM [dbo].[RecentActivity] JOIN dbo.Users AS UserE ON UserE.UserId =[RecentActivity].TableID AND [RecentActivity].TableName ='Userd' AND [RecentActivity].fieldName='UserId'

  JOIN SystemValues ON SystemValues.systemvalueno=[RecentActivity].[ActivityType] AND SystemValues.SystemTableNo=57 AND [RecentActivity].[ActivityType] IN (24,25)
   
    LEFT OUTER JOIN users ON users.UserId=[RecentActivity].UserId
	LEFT OUTER JOIN dbo.UsersStore  ON UserE.UserId=UsersStore.UserID
  LEFT OUTER JOIN dbo.Groups ON Groups.GroupID = UsersStore.GroupID





UNION ALL

SELECT  DISTINCT  TOP 100000  CONVERT(VARCHAR(MAX), RegShiftEntry.RegDetailID) ,4,'Logout' ,

'<b'+ISNULL(LTRIM(ISNULL(users.UserFName,'')+' '+ISNULL(users.UserLName,'')),users.UserName)+' b> signed out from register'  , RegShiftEntry.LogOutTime, NULL,'',users.UserName,'',NULL
FROM            RegShiftEntry INNER JOIN
                         Users ON RegShiftEntry.UserID = Users.UserId
GO
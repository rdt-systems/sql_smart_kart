SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SP_PhoneOrderMissingSummerry] (@date datetime)

AS

SELECT        P.PhoneOrderID, P.PhoneOrderNo, P.PhoneOrderDate, P.PhoneOrderTime, O.PhoneOrderEntryID, O.ItemStoreNo, O.Qty, O.Note, P.TransactionID
INTO              [#POrder]
FROM            PhoneOrder AS P INNER JOIN
                         PhoneOrderEntry AS O ON P.PhoneOrderID = O.PhoneOrderID
WHERE        (P.Status > 0) AND (O.Status > 0) AND (P.PhoneOrderDate >= @date) AND (P.TransactionID IS NOT NULL)


SELECT        T.TransactionID, T.TransactionNo, T.Debit, T.Credit, T.StartSaleTime, E.TransactionEntryID, E.ItemStoreID, E.Qty
INTO              [#Sale]
FROM            [Transaction] AS T INNER JOIN
                         TransactionEntry AS E ON T.TransactionID = E.TransactionID
WHERE        (T.Status > 0) AND (E.Status > 0) AND (E.TransactionEntryType <> 4) AND (E.TransactionEntryType <> 5) AND (T.StartSaleTime >= @date)


SELECT        O.PhoneOrderNo, O.PhoneOrderID, O.Qty, O.ItemStoreNo, O.Note, O.PhoneOrderDate, O.PhoneOrderEntryID, S.TransactionNo, S.TransactionID, S.TransactionEntryID, S.Qty AS Expr1, S.ItemStoreID, S.StartSaleTime
INTO              [#Filled]
FROM            [#POrder] AS O INNER JOIN
                         [#Sale] AS S ON O.TransactionID = S.TransactionID AND O.ItemStoreNo = S.ItemStoreID


SELECT        SUM(R.Qty) AS Qty, I.Name, I.ModalNumber, I.BarcodeNumber
FROM            [#POrder] AS R INNER JOIN
                         ItemMainAndStoreGrid AS I ON R.ItemStoreNo = I.ItemStoreID
WHERE        (R.PhoneOrderEntryID NOT IN
                             (SELECT        PhoneOrderEntryID
                               FROM            [#Filled])) AND (I.ItemType <> 3) AND (I.ItemType <> 5) AND (I.ItemType <> 9)
GROUP BY I.Name, I.ModalNumber, I.BarcodeNumber


DROP TABLE [#POrder]
DROP TABLE [#Sale]
DROP TABLE [#Filled]
GO
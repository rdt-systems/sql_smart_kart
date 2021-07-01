SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SP_GetEizerReport](
	@Date datetime = NULL)
AS

IF @Date IS NULL
SELECT @Date = dbo.GetLocalDate()

IF EXISTS(SELECT 1 FROM [Transaction] WHERE (TransactionNo LIKE 'EL%') AND (TransactionType = 4) AND (Note = 'Eizer Lemuzon') AND (StartSaleTime >= CAST(@Date-9 AS date)))
SELECT        CONVERT(VARCHAR, T.StartSaleTime, 101) AS Date, C.LastName, C.FirstName AS Name, C.Address, REPLACE(ISNULL(C.Phone, C.CustomerNo), '(914)', '(845)') AS Tel, G.CustomerGroupName AS DonationGroup, 
                         T.Debit AS Donation, T.TransactionNo AS [Donation Ticket], CASE WHEN DATEDIFF(d, C.LastDateCleared, dbo.GetLocalDate()) < 16 THEN 'TRUE' ELSE 'FALSE' END AS IsActive, CASE WHEN DATEDIFF(d, C.LastSaleDate, 
                         dbo.GetLocalDate()) < 10 THEN 'TRUE' ELSE 'FALSE' END AS IsCustomer
FROM            CustomerView AS C INNER JOIN
                         CustomerToGroup AS CG ON C.CustomerID = CG.CustomerID AND CG.Status > 0 INNER JOIN
                         CustomerGroup AS G ON CG.CustomerGroupID = G.CustomerGroupID AND G.Status > 0 AND G.CustomerGroupName LIKE '%EIZ%' LEFT OUTER JOIN
                         [Transaction] AS T ON C.CustomerID = T.CustomerID AND T.Status > 0 AND T.TransactionNo LIKE 'EL%' AND T.TransactionType = 4 AND T.Note = 'Eizer Lemuzon' AND T.StartSaleTime >= CAST(@Date - 9 AS date) AND 
                         T.StartSaleTime < CAST(@Date - 1 AS date)
ORDER BY T.StartSaleTime
GO
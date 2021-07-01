SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[Rpt_BalanceCustomer]
(@asDate datetime)
AS

SELECT     CustomerID, [Name], 
	       ISNULL ((SELECT     SUM(LeftDebitsView.LeftDebit)
                              FROM         LeftDebitsView
                              WHERE     LeftDebitsView.CustomerID = Customer.CustomerID), 0) AS Debit, 
	       ISNULL ((SELECT  SUM(LeftDebitsView.LeftDebit)
                              FROM         LeftDebitsView
                              WHERE     LeftDebitsView.DueDate >@asDate  AND LeftDebitsView.CustomerID = Customer.CustomerID), 0) AS Currentc, 
	       ISNULL ((SELECT     SUM(LeftDebitsView.LeftDebit)
                              FROM         LeftDebitsView
                              WHERE     LeftDebitsView.DueDate <= @asDate AND LeftDebitsView.DueDate > DATEADD(day, - 30, @asDate) 
			           AND LeftDebitsView.CustomerID = Customer.CustomerID), 0) AS Till30, 
                      ISNULL ((SELECT     SUM(LeftDebitsView.LeftDebit)
                              FROM         LeftDebitsView
                              WHERE     LeftDebitsView.DueDate <= DATEADD(day, - 30, @asDate) AND LeftDebitsView.DueDate > DATEADD(day, - 60, @asDate) 
                                                    AND LeftDebitsView.CustomerID = Customer.CustomerID), 0) AS From30, 
	        ISNULL ((SELECT     SUM(LeftDebitsView.LeftDebit)
                              FROM         LeftDebitsView
                              WHERE     LeftDebitsView.DueDate <= DATEADD(day, - 60, @asDate) AND LeftDebitsView.DueDate > DATEADD(day, - 90, @asDate) 
                                                    AND LeftDebitsView.CustomerID = Customer.CustomerID), 0) AS From60, 
	        ISNULL ((SELECT     SUM(LeftDebitsView.LeftDebit)
                              FROM         LeftDebitsView
                              WHERE     LeftDebitsView.DueDate <= DATEADD(day, - 90, @asDate) AND LeftDebitsView.DueDate > DATEADD(day, - 120, @asDate) 
                                                    AND LeftDebitsView.CustomerID = Customer.CustomerID), 0) AS From90, 
	        ISNULL ((SELECT     SUM(LeftDebitsView.LeftDebit)
                              FROM         LeftDebitsView
                              WHERE     LeftDebitsView.DueDate <= DATEADD(day, - 120, @asDate) AND LeftDebitsView.CustomerID = Customer.CustomerID), 0)  AS From120
FROM         dbo.CustomerView Customer
WHERE     (Status > - 1)
GO
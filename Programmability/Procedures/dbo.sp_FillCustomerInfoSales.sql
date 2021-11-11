SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
-- =============================================
-- Author:      Nathan Ehrenthal
-- Create Date: 11/11/2021
-- Description: to fill CustomerSaleInfoTable
-- =============================================
CREATE PROCEDURE [dbo].[sp_FillCustomerInfoSales]

AS
BEGIN
  DELETE FROM CustomerSaleInfo

  INSERT INTO CustomerSaleInfo (CustomerID, Visit, LastVisit, AverageAmount, TotalSpent, Last12MonthsTrans,Last90DaysTrans)
  (SELECT C.CustomerID, C.Visit, C.LastVisit, C.AverageAmount, C.TotalSpent,ISNULL( T.T12,0),ISNULL(T.T90,0) FROM 	
  ( SELECT        CustomerID,COUNT(TransactionID) AS Visit, MAX(StartSaleTime) AS LastVisit,  AVG(Debit) AS AverageAmount,Sum(Debit) as TotalSpent
	FROM            dbo.[Transaction] WITH (NOLOCK)
	WHERE     CustomerID IS NOT NULL AND   (Status > 0)
	GROUP BY CustomerID 
	)AS C LEFT JOIN (SELECT        CustomerID, 
		SUM(CASE WHEN (StartSaleTime> dbo.GetLocalDate()-90) THEN 1 ELSE 0 END) AS T90,
		SUM(CASE WHEN (StartSaleTime> dbo.GetLocalDate()-365) THEN 1 ELSE 0 END) AS T12
		FROM            dbo.[Transaction] WITH (NOLOCK)
		WHERE        (Status > 0) AND CustomerID IS NOT NULL
		GROUP BY CustomerID) AS T ON C.CustomerID=T.CustomerID )

END
GO
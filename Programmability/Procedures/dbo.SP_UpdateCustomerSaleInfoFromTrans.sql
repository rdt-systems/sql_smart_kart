SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
-- =============================================
-- Author:      Nathan Ehrenthal
-- Create Date: <Create Date, , >
-- Description: <Description, , >
-- =============================================
CREATE PROCEDURE [dbo].[SP_UpdateCustomerSaleInfoFromTrans]
(
   @CustomerID UNIQUEIDENTIFIER,
   @SaleAmount DECIMAL(18,3) 
)
AS

BEGIN
 IF (SELECT COUNT(*) FROM CustomerSaleInfo csi WHERE csi.CustomerID=@CustomerID)=0
 BEGIN
   INSERT INTO CustomerSaleInfo (CustomerID, Visit, LastVisit, AverageAmount, TotalSpent, Last12MonthsTrans,Last90DaysTrans)
	VALUES (@CustomerID, 1, dbo.GetLocalDate(), @SaleAmount, @SaleAmount, 1,1);	
 END
 ELSE
 BEGIN
 	UPDATE CustomerSaleInfo 
	SET Visit =Visit+ 1
	   ,LastVisit = dbo.GetLocalDate()
	   ,AverageAmount = ((TotalSpent+@SaleAmount)/(Visit+1))
	   ,TotalSpent = TotalSpent+@SaleAmount
	   ,Last12MonthsTrans=Last12MonthsTrans+1
	   ,Last90DaysTrans=Last90DaysTrans+1
	WHERE CustomerID = @CustomerID;
 END

END
GO
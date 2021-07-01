SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SP_GetItemsByDepartment]
(@StoreID uniqueidentifier,
@DepartmentID uniqueidentifier)
AS 
	SELECT     ItemID, 
		   Name,
		   BarcodeNumber,
		   ModalNumber, 
		   OnOrder, 
		   OnHand, 
		   Cost, 
		   Cost * OnHand AS ExtCost, 
		   DepartmentID, 
		   Department, 
		   Price, 
	           Price * OnHand AS ExtPrice,
		   Price * OnHand - Cost * OnHand AS Profit,

                   (SELECT CASE WHEN Price = 0 THEN 0 
		                    ELSE (Price - Cost) / Price * 100 
		    END) AS Margin,

                   (SELECT CASE WHEN Cost = 0 THEN 0 
		                ELSE (Price - Cost) / Cost * 100 
		    END) AS Markup

	FROM       dbo.ItemPiece

	WHERE     (StoreNo = @StoreID) AND (DepartmentID = @DepartmentID)
GO
SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SP_GetBuyersForSupplier](
	@SupplierID Uniqueidentifier,
	@StoreID Uniqueidentifier = NULL
	)
AS

SELECT      Users.UserName ,Buyers.UserID   
FROM            Buyers INNER JOIN
                         Users ON Buyers.UserID = Users.UserId
WHERE        (Buyers.Status > 0) AND (Users.Status > 0) AND (Buyers.SupplierID = @SupplierID)
GO
SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SP_DeliveryDetails]  
(
 @Filter nvarchar(4000) = ''
)
AS
 DECLARE @Query  nvarchar(2000)
SET @Query = 'SELECT * FROM DeliveryDetailsView '
BEGIN
--print (@Query)
EXEC (@Query + @Filter + ' Order By StreetName, HouseNo ')
END
GO
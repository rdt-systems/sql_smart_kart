SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


---Sp Created to show records for Customer Transcation By shipping report

CREATE PROCEDURE [dbo].[SP_DeliveryDetailsPrint]  
(
 @Filter nvarchar(4000) = ''
)
AS
 DECLARE @Query  nvarchar(2000)
SET @Query = 'SELECT * FROM DeliveryDetailsView'

      BEGIN

       EXEC (@Query + @Filter )
      END
GO
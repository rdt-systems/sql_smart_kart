SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SP_GetRecieTxtDelivery]
(
 @Filter nvarchar(4000) = ''
)
AS
 DECLARE @Query  nvarchar(2000)
SET @Query = 'SELECT * FROM RecieptDelivery '

      BEGIN
           EXEC (@Query + @Filter )
      END
GO
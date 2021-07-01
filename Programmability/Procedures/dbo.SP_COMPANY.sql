SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SP_COMPANY]
(
@DateModified datetime=null,
@storeID uniqueidentifier,
@ActiveOnly bit =1
)
AS 

SELECT CAST(EncData AS nvarchar(4000)) AS COMPANY, 'A' As Temp, DateModified, 1 As Status From Encdata WHERE Type ='POS' AND StoreID =@storeID AND (DateModified  > @DateModified)  AND Status>0
GO
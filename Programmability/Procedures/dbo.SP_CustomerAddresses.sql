SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SP_CustomerAddresses]
(
@DateModified datetime=null
)
AS 

SELECT [CustomerAddresses].*  FROM [CustomerAddresses]   WHERE (DateModified > @DateModified) AND Status>0
GO
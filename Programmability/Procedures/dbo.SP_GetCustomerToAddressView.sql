SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SP_GetCustomerToAddressView]
( @refreshTime  datetime output)
AS
GO
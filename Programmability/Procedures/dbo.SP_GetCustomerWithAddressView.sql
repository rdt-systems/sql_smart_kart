SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SP_GetCustomerWithAddressView] AS

select * from CustomerWithAddressView
Where CustomerWithAddressView.status>-1
GO
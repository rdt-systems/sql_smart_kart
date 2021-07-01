SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE Procedure [dbo].[SP_GetCustomerActiveties] (
	@FromDate Datetime, 
	@ToDate datetime)
AS

SELECT        CustomerNo, LastName, FirstName, FullName, Address, CityStateAndZip, BalanceDoe, CurrentCreditLine, OldCreditLine, NewCreditLine, DateChanged, UserChanged
FROM            CustomerActivatyView
WHERE        (DateChanged >= @FromDate) AND (DateChanged < @Todate + 1)
GO
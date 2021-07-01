SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE VIEW [dbo].[_dta_mv_8]  
 AS 
SELECT  [dbo].[Customer].[Status] as _col_1,  [dbo].[CustomerAddresses].[Status] as _col_2,  [dbo].[Customer].[DateModified] as _col_3,  [dbo].[CustomerAddresses].[CustomerAddressID] as _col_4 FROM  [dbo].[CustomerAddresses],  [dbo].[Customer]   WHERE  [dbo].[CustomerAddresses].[CustomerID] = [dbo].[Customer].[CustomerID]
GO
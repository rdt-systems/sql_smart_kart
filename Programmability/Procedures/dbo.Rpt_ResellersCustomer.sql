SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[Rpt_ResellersCustomer] AS

select CustomerWithAddressView.*,resellersview.Name ResellerName from CustomerWithAddressView
left outer join resellersview on CustomerWithAddressView.resellerID=resellersview.resellerID
Where CustomerWithAddressView.status>0 and CustomerWithAddressView.resellerID is not null
GO
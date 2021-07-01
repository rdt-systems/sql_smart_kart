SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO



CREATE       VIEW [dbo].[CustomerAddressesView]
AS
SELECT     dbo.CustomerAddresses.*
FROM         dbo.CustomerAddresses
GO
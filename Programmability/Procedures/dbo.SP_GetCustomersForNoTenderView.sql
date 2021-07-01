SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SP_GetCustomersForNoTenderView]

(
@CustomerID uniqueidentifier
)
AS


SELECT     dbo.CustomersForNoTenderview .*
FROM         dbo.CustomersForNoTenderview
Where CustomerId = @CustomerID
GO
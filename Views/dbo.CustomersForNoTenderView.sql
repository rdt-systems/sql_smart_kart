SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE VIEW [dbo].[CustomersForNoTenderView]
AS
SELECT     CustomersForNoTenderID, CustomerId, TenderId, Status, DateCreated, UserCreated, DateModified, UserModified
FROM         dbo.CustomersForNoTender
GO
SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE VIEW [dbo].[SpecialCustomerGroupView]
AS
SELECT        dbo.SpecialCustomerGroup.*
FROM            dbo.SpecialCustomerGroup
WHERE        (Status > 0)
GO
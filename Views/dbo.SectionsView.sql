SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO



CREATE View [dbo].[SectionsView]
AS

SELECT       DISTINCT CustomerToGroup.CustomerID, CustomerGroup.CustomerGroupName AS Zone
FROM            CustomerToGroup INNER JOIN
                         CustomerGroup ON CustomerToGroup.CustomerGroupID = CustomerGroup.CustomerGroupID
WHERE        (CustomerGroup.Sort = 0) AND (CustomerGroup.Status > 0) AND (CustomerToGroup.Status > 0)
GO
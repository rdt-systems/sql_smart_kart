SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE View [dbo].[CustomerRepFilter]
as
SELECT        Customer.CustomerID, Customer.CustomerNo, CustomerAddresses.Name, ISNULL(CustomerToGroup.CustomerGroupID, '00000000-0000-0000-0000-000000000000') AS CustomerGroupID, 
                         Customer.CustomerType, Customer.PriceLevelID, Customer.DiscountID, CustomerAddresses.Zip, Customer.TaxExempt
FROM            Customer LEFT OUTER JOIN
                             (SELECT        CustomerToGroupID, CustomerGroupID, CustomerID, Status, DateModified
                               FROM            CustomerToGroup
                               WHERE        (Status > 0)) AS CustomerToGroup ON Customer.CustomerID = CustomerToGroup.CustomerID AND CustomerToGroup.Status > 0 LEFT OUTER JOIN
                         CustomerAddresses ON Customer.CustomerID = CustomerAddresses.CustomerID AND CustomerAddresses.Status > 0
WHERE        (Customer.Status > - 1)
GO
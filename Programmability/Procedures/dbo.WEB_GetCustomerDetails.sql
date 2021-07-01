SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


create PROCEDURE [dbo].[WEB_GetCustomerDetails] 
(@CustomerID uniqueidentifier)
AS
	
SELECT    FirstName, LastName,Password, '' AS EmailAddress
FROM         Customer
WHERE     (Status > 0) AND (CustomerID = @CustomerID)
UNION ALL
SELECT     '' AS FirstName,'' AS LastName,''as Password, EmailAddress
FROM         Email
WHERE     (Status > 0) AND (EmailID =
       (SELECT     EmailID
        FROM          CustomerToEmail
         WHERE      (Status > 0) AND (CustomerID = @CustomerID) AND (DateModified =
                 (SELECT     MAX(DateModified) AS Expr1
                  FROM          CustomerToEmail AS CustomerToEmail_1
                  WHERE      (Status > 0) AND (CustomerID = @CustomerID)))))
GO
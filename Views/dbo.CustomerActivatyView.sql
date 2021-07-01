SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE VIEW [dbo].[CustomerActivatyView]
AS
SELECT        C.CustomerNo, C.LastName, C.FirstName, CASE WHEN ISNULL(C.LastName, '') <> '' AND ISNULL(C.FirstName, '') <> '' THEN LastName + ', ' WHEN ISNULL(C.LastName, '') <> '' AND ISNULL(C.FirstName, '') 
                         = '' THEN LastName ELSE '' END + CASE WHEN ISNULL(C.FirstName, '') <> '' THEN C.FirstName ELSE '' END AS FullName, C.Address, C.CityStateAndZip, C.BalanceDoe, C.Credit AS CurrentCreditLine, 
                         CA.OldCreditLine, CA.NewCreditLine, CA.DateCreated AS DateChanged, Users.UserName AS UserChanged
FROM            CustomerActivaty AS CA INNER JOIN
                         CustomerView AS C ON CA.CustomerID = C.CustomerID INNER JOIN
                         Users ON CA.UserCreated = Users.UserId
						 Where CA.Status >0
GO
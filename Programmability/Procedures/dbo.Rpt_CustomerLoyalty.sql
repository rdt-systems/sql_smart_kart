SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[Rpt_CustomerLoyalty](
    @Filter nvarchar(4000)
)
as

declare @MySelect nvarchar(2000)
set @MySelect='
 SELECT t.TransactionNo, ISNULL((c.LastName +'' ''+ c.FirstName),c.LastName) as CustomerName, c.CustomerNo, l.DateCreated, l.Points, l.AvailPoints, t.Debit
    FROM Loyalty l
    INNER JOIN Customer c ON l.CustomerID = c.CustomerID
    INNER JOIN [Transaction] t ON t.TransactionID = l.TransactionID '


exec(@MySelect+@Filter)
print(@MySelect+@Filter)
GO
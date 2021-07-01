SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE procedure [dbo].[SP_GetPointsPriceVerifier]
(@CardNumber  nvarchar(50)= null,
@CustomerID uniqueidentifier = null )
  AS
  
IF @CustomerID is null 
 begin
  Select SUM(l.AvailPoints) AS Balance from CustomerMemberCards cm 
  Inner join Loyalty l on cm.CustomerID = l.CustomerID 
  Where cm.CardNumber = @CardNumber AND cm.Status > 0 end
else begin
  Select SUM(l.AvailPoints) AS Balance from Loyalty l Where l.CustomerID = @CustomerID
 AND l.Status > 0
END
GO
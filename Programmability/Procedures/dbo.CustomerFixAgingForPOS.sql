SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[CustomerFixAgingForPOS] 
(@CustomerID uniqueidentifier,
 @Over0 money,
 @Over30 money,
 @Over60 Money,
 @Over90 money,
 @over120 money)
AS


update Customer
set
[Current]=@Over0,
Over0= @Over0 ,
Over30=@Over30 ,
Over60=@Over60 ,
Over90=@Over90 ,
Over120=@Over120 ,
DateModified=dbo.GetLocalDATE()
WHERE CustomerID=@CustomerID
GO
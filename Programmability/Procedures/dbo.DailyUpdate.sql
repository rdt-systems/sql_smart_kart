SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[DailyUpdate] AS
update Customer
set BalanceDoe=isnull((select sum(debit-credit) from [transaction] where status>0 and CustomerID=Customer.CustomerID ),0),
DateModified=dbo.GetLocalDATE()
GO
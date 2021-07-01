SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SP_SalesDelete]
(@SaleID	uniqueidentifier)
as
update Sales
set Status=-1, datemodified=dbo.GetLocalDATE()
where SaleID=@SaleID
and status>0
GO
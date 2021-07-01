SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


create PROCEDURE [dbo].[SP_SaleTimesDelete]
(@SaleTimeID uniqueidentifier,
@ModifierID uniqueidentifier)
AS update dbo.SaleTimes
set

Status =-1
where SaleTimeID=@SaleTimeID
GO
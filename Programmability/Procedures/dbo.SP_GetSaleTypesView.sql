SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


create PROCEDURE [dbo].[SP_GetSaleTypesView]

As 


select * from dbo.SaleTypesView
GO
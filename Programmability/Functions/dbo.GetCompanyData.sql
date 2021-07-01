SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE FUNCTION [dbo].[GetCompanyData] (@StoreID uniqueidentifier) RETURNS nvarchar(4000)
AS
BEGIN	
	RETURN dbo.GetCompData((select top 1 dbo.EncData.EncData from dbo.EncData),@StoreID)
END
GO
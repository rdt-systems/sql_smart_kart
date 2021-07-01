SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SP_GetOneSetUpValue]
@StoreID  uniqueidentifier =null,
@OptionName nvarchar(4000)
as

select * from SetUpValuesView
where StoreID=@StoreID and optionname=@OptionName
GO
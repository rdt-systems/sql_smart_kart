SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SP_GetSetUpValuesView]
@StoreID  uniqueidentifier =null
as

select * from SetUpValuesView
where StoreID=@StoreID or  StoreID='00000000-0000-0000-0000-000000000000'


--If (SELECT Count(*)
--   FROM SetUpValues
--   Where OptionID=999)=0
--
--INSERT INTO SetUpValues(OptionID,OptionValue)
--			VALUES (999,@StoreID)
GO
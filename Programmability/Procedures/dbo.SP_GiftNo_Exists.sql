SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


create PROCEDURE [dbo].[SP_GiftNo_Exists]
(@Number nvarchar(50),
@GiftID uniqueidentifier=null)
As 

if (select Count(1) from dbo.gift
	where GiftNumber = @Number  and Status>-1 and (GiftID<>@GiftID or @GiftID is null)) > 0
	select 1	
else
	select 0
GO
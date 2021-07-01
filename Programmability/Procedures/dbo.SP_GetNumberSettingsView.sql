SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SP_GetNumberSettingsView]
@StoreID uniqueidentifier=null

AS
if @StoreID is null
begin
	SELECT     dbo.NumberSettingsView.*
	FROM         dbo.NumberSettingsView
end
--   add by NE 
ELSE
BEGIN
	SELECT     dbo.NumberSettingsView.*
	FROM         dbo.NumberSettingsView
	where StoreID=@StoreID
END
--   ebd add



--            coment by NE  
--else
--	If (SELECT     COUNT(*) FROM         dbo.NumberSettingsView WHERE TableName = 'ItemsMain' And StoreID=@StoreID) =0
--	Begin
--		SELECT     dbo.NumberSettingsView.*
--		FROM         dbo.NumberSettingsView
--	End
--	Else
--	Begin
--		SELECT     dbo.NumberSettingsView.*
--		FROM         dbo.NumberSettingsView
--		where StoreID=@StoreID
--	End
GO
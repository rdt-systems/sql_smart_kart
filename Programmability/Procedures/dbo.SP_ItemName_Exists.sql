SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SP_ItemName_Exists]
(@Name nvarchar(50))
As 

declare @msg nvarchar(50)
declare @vItemID nvarchar(50)

--if (select Count(1) from dbo.ItemMain WHERE (Name = @Name ) and (Status>-1))>0
--begin
--	if (select Count(1) from dbo.ItemMain WHERE (Name = @Name ) and status=0)>0
--		Begin
--			select top 1 @vItemID = isnull(BarcodeNumber,'') from dbo.ItemMain WHERE (Name = @Name ) and status=0
--			Begin
--					  set @msg ='Name: '+@Name+' Exist and it is Inactive UPC: '+@vItemID
--			end
--		end
--	else
--		  set @msg ='Name '+@Name+' Exist'
--end
--ELSE
	Set @msg =''

	
SELECT @msg
GO
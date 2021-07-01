SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SP_GetManuByItem]
(@Filter nvarchar(4000)='')AS
declare @MySelect nvarchar(4000)

if @Filter=''

	begin
	set @MySelect=
	
		'select ManufacturerID,ManufacturerName from Manufacturers
		where  Manufacturers.Status=1 '
		exec(@MySelect)
	
	
	end 
else

	 begin
	set @MySelect=
	
		'select ManufacturerID,ManufacturerName from Manufacturers
		where  Manufacturers.Status=1 and  exists(select 1 from ItemMain where dbo.ItemMain.ManufacturerID = dbo.Manufacturers.ManufacturerID and
		ItemID in'
		
		exec(@MySelect+@Filter+')')

	end
GO
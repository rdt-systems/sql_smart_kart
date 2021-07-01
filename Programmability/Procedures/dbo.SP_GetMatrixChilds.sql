SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE procedure [dbo].[SP_GetMatrixChilds]
(@ID uniqueidentifier,
@ItemMainOnly bit = 0)

 as
 if @ItemMainOnly = 0 
Begin
select * 
from dbo.ItemMainAndStoreGrid
where LinkNo=@ID And Status>-1
end
else if @ItemMainOnly = 1
begin
select * 
from dbo.ItemMain
where LinkNo=@ID And Status>-1
end
GO
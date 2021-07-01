SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SP_GetItemMainAndStorePages](@Recordes nvarchar(10),--Recordes on a page
                                                      @Filter nvarchar(4000)='',
                                                      @StoreID nvarchar(60),
                                                      @FromStatus as nvarchar(3))
AS 
    DECLARE @Select  nvarchar(2000) 
  set @Select =' SELECT (COUNT(*)/'+@Recordes+')+1 As Pages FROM ItemMainAndStoreView  WHERE
                 StoreNo = '''+ @StoreID+''' AND Status>'+@FromStatus 
                exec(@Select +@Filter)
                 --print (@Select +@Filter)
GO
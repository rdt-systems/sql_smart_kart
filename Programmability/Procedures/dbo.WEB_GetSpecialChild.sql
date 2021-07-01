SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[WEB_GetSpecialChild]
(@Item1 nvarchar(50)='bg62',
@Item2 nvarchar(50)='s104',
@Item3 nvarchar(50)='E235',
@Item4 nvarchar(50)='nc105')

AS 


   SELECT     Matrix1,LinkNo,ItemStoreID,Price
			
FROM         dbo.ItemMainAndStoreView
where status>0 and linkno in
(select itemid from itemmain
where barcodenumber in (@Item1,@Item2,@Item3,@Item4)
and status>0)

--'bg62','s104','E235','nc105'
GO
SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE procedure [dbo].[SP_SecuirtyOfColumnsInsert]
(@GroupID uniqueidentifier,
 @GridType NvarChar(50),
 @ColumnName NvarChar(50)='',
 @DeleteRows bit=0)
as
if @DeleteRows=1 
   Delete From SecurityOfColumns where GroupID=@GroupID and GridType=@GridType

if @ColumnName<>''
insert into dbo.SecurityOfColumns(GroupID,GridType,ColumnName)
		values(@GroupID,@GridType,@ColumnName)
GO
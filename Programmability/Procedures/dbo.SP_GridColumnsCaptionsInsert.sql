SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


create procedure [dbo].[SP_GridColumnsCaptionsInsert]
(@GridNumber int,
@FieldName nvarchar(50),
@FieldCaption nvarchar(50))
as 
insert into  dbo.GridColumnsCaptions 
(GridNumber,FieldName,FieldCaption)
values
(@GridNumber,@FieldName,@FieldCaption)
GO
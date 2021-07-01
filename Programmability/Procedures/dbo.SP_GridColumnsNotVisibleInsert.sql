SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


create procedure [dbo].[SP_GridColumnsNotVisibleInsert]
(@GridNumber int,
@FieldName nvarchar(50))

as 
insert into  dbo.GridColumnsNotVisible
(GridNumber,FieldName)
values
(@GridNumber,@FieldName)
GO
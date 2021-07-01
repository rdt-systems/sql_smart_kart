SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
create procedure [dbo].[p_x]
as
begin
declare @t table(col1 varchar(10), col2 float, col3 float, col4 float)
insert @t values('a', 1,1,1)
insert @t values('b', 2,2,2)

select * from @t
end
GO
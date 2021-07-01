SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


 --select [dbo].[encript]('1')


CREATE FUNCTION [dbo].[encript](@d varchar(4000))
RETURNS  varchar(4000)  AS  
BEGIN 


--DECLARE @d varchar(500)='1234567812345678'
DECLARE @cnt INT = 1;
declare @ss varchar(500)='5eEhKAJksgXnBlVu'
declare @s2 varchar(500)=''
declare @s1 varchar(500)=''
declare @result varchar(500)=''
declare @x int=0
declare @x2 int

set @s1=@ss

set @s1 ='0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz+/'



--print @cnt
--print  len(@d)

--print  len(@ss)
WHILE @cnt <= len(@ss)
BEGIN
   --print CHARINDEX (substring(@d,@cnt,1),@ss)
   set @x =CHARINDEX (substring(@ss,@cnt,1),@s1 COLLATE Latin1_General_CS_AS)
 --  print '@x is '+ convert(varchar(max),@x)
   If @x > 0
   begin 
 --  print substring(@s1,1,@x-1)
 --  print SUBSTRING(@s1,@x+1,len(@s1)-@x);
   set  @s1 =substring(@s1,1,@x-1) +SUBSTRING(@s1,@x+1,len(@s1)-@x);
 -- print @s1
   end  
   SET @cnt = @cnt + 1;
END;

--print @s1

set @cnt=1
WHILE @cnt <= len(@d)

BEGIN
--print @ss
set @s2 = @s2+substring(@ss,   ascii(substring(@d,@cnt,1))-48+1,1)
--print @s2
set @ss = [dbo].[MoveCharacter](@ss)
--print @ss
set @s2 = @s2+substring(@ss,   floor(ascii(substring(@d,@cnt,1))/16)+1,1)
--print @s2
set @ss = [dbo].[MoveCharacter](@ss)
--print @ss



   SET @cnt = @cnt + 1;
END;

set @result=[dbo].MakeRNDString(@s1,dbo.Random(1,10,(select random_value from random_val_view)))


set @cnt=1
WHILE @cnt <= len(@s2)

BEGIN
set @result=@result+ substring(@s2,@cnt,1)+[dbo].MakeRNDString(@s1,dbo.Random(1,10,(select random_value from random_val_view)))

   SET @cnt = @cnt + 1;
END;

--select @result;
return @result

END

--select [dbo].[decript]('vyqexyqpjoiadE+yvoqdfjaW5ztxq5wyxrqofuwVV+tqwrBwvtrlzypoqjdXyvrBztswzxqiomnxyprJwvrtXwzxrijmbKzxevtqpoExrwopmf5yz5uwvqpVzxwV+rqpjifdBwxvrqjlywprojmXBzvqwpicjswyqtnvyJxtymiqdXzwvpmoKxytrmfidc')
GO
SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE FUNCTION [dbo].[decript](@d varchar(4000))
RETURNS  varchar(4000)  AS  
BEGIN 


--DECLARE @d varchar(500)='+wx/rzte/+xyrvE5zw5+xwt/u/V/z+wrvqtVzwBxlyxzvt/wrX/xyBsnxy/tzJ+wxytXxKxzvy+/pezyvEyw/vx5yw+t5+xzyrq/owuzywtVywxz/tpqmVxw/Bzwylzxv/t+rwoX/zywrvqoxByz+/vxwsxzyw/r+tvn/x+vrJzx/w+rtqoX+/ytvrzKz/yw+'
DECLARE @cnt INT = 0;
declare @ss varchar(500)='5eEhKAJksgXnBlVu'
declare @s2 varchar(500)=''
declare @x int=0
declare @x2 int

--print @cnt
--print  len(@d)
WHILE @cnt <= len(@d)
BEGIN
   --print CHARINDEX (substring(@d,@cnt,1),@ss)
   If CHARINDEX (substring(@d,@cnt,1),@ss COLLATE Latin1_General_CS_AS) > 0
   begin 
   set  @s2 = @s2 + substring(@d,@cnt,1)
  --print @s2
   end  
   SET @cnt = @cnt + 1;
END;
set @d= @s2;
set @s2 ='';
SET @cnt =0;
--print @d
--print @cnt
--print  len(@d)
--print  (len(@d)/2)
WHILE @cnt < (len(@d)/2)
BEGIN
--print @cnt
--print '@ss is '+ @ss
--print '@d is '+@d
--print 'substring is '+ substring(@d,(@cnt*2)+1,1)
   set @x = CHARINDEX (substring(@d,(@cnt*2)+1,1),@ss COLLATE Latin1_General_CS_AS)-1
   --	print 'x is ' + convert(varchar, @x)
                If @x < 0 
				begin 
				set @cnt =99
				end 

               set  @ss =  [dbo].[MoveCharacter](@ss)
			 --  print  'substring2 is ' +substring(@d,(@cnt * 2 + 2) - 1+1,1)
			  --- print @ss
    			set @x2= CHARINDEX (substring(@d,(@cnt * 2 + 2) - 1+1,1),@ss COLLATE Latin1_General_CS_AS)-1
			--	print 'x2 is ' + convert(varchar, @x2)
              If @x2 < 0 
				begin 
				set @cnt =99
				end 

                set @x = @x + @x2 * 16
			--	print 'xx is ' + convert(varchar, @x) 
                set @s2 = @s2 + char(@x)
			--	print @s2
                set  @ss =  [dbo].[MoveCharacter](@ss)


   SET @cnt = @cnt + 1;
END;

return @s2

END
GO
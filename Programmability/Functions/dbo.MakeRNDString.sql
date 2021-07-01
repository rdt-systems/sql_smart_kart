SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE FUNCTION [dbo].[MakeRNDString]( @Chars  varchar(100),  @CountString As int)
RETURNS varchar (max)
       AS
	   BEGIN
	   --DECLARE @Chars varchar(max)  = '012346789CDFGHILMNOPQRSTUWYZabcdfijmopqrtvwxyz+/';
	   --DECLARE @CountString int =5;
            DECLARE @x  int;
            DECLARE @Result varchar(max)  = '';
			DECLARE @cnt int  = 0;

			WHILE @cnt <= @CountString-1

			BEGIN


			

            --For i As Integer = 0 To @CountString - 1
              set  @x = len(@Chars) - dbo.Random(1,5,(select random_value from random_val_view))
               set @Result = @Result + substring( @Chars,@x - 1,1)
               set @Chars =convert(varchar(max),Substring( @Chars,0, @x - 1)) +convert(varchar(max),Substring( @Chars,@x, len(@Chars) - @x))
               set @cnt = @cnt + 1;
			END;
			--select @Result
            Return @Result
     

    End
GO
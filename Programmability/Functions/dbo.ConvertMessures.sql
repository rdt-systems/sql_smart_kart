SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE function [dbo].[ConvertMessures](@Meaasure Int, @Units decimal,@Price money) returns nvarchar(50) 
as begin 
  DECLARE @RET varchar(50)
  IF @Meaasure=0 or @Units=0 or @Price=0 SET @RET=''
  ELSE IF @Meaasure=1  SET @RET=  '$'+CONVERT(nvarchar,Cast((@Price/(0.0625 * @Units))as decimal(10,2)), 110) + '\Lb.' --Oz
  ELSE IF @Meaasure=2  SET @RET=  '$'+CONVERT(nvarchar,Cast((@Price/(1 * @Units))as decimal(10,2)), 110) + '\Lb.' --Oz
  ELSE IF @Meaasure=6  SET @RET=  '$'+CONVERT(nvarchar,Cast((@Price/(453.592 * @Units))as decimal(10,2)), 110) + '\Lb.' --GR
  ELSE IF @Meaasure=27 SET @RET=  '$'+CONVERT(nvarchar,Cast((@Price/(453592 * @Units))as decimal(10,2)), 110) + '\Lb.'  --Mg
  ELSE IF @Meaasure=5  SET @RET=  '$'+CONVERT(nvarchar,Cast((@Price/(0.453592 * @Units))as decimal(10,2)), 110) + '\Lb.'--Kg

  ELSE IF @Meaasure=7   SET @RET= '$'+CONVERT(nvarchar,Cast((@Price/(1.05669 * @Units))as decimal(10,2)), 110) + '\Qt.'--Lt
  ELSE IF @Meaasure= 20 SET @RET= '$'+CONVERT(nvarchar,Cast(((1.39/(946.353)) * 100)as decimal(10,2)), 110) + '\Qt.'--Ml
  ELSE IF @Meaasure= 17 SET @RET= '$'+CONVERT(nvarchar,Cast((@Price/(0.03125  * @Units))as decimal(10,2)), 110) + '\Qt.'--Fl oz                  
  ELSE IF @Meaasure= 18 SET @RET= '$'+CONVERT(nvarchar,Cast((@Price/(2 * @Units))as decimal(10,2)), 110) + '\Qt.'--Pt
  ELSE IF @Meaasure= 8  SET @RET= '$'+CONVERT(nvarchar,Cast((@Price/(4 * @Units))as decimal(10,2)), 110) + '\Qt.'--Gl

  ELSE IF @Meaasure=25  SET @RET= '$'+CONVERT(nvarchar,Cast((@Price/(0.333333 * @Units))as decimal(10,2)), 110) + '\Ft.'--Yd 
  ELSE IF @Meaasure=26  SET @RET= '$'+CONVERT(nvarchar,Cast((@Price/(12 * @Units))as decimal(10,2)), 110) + '\Ft.'--Inch
  ELSE IF @Meaasure=14  SET @RET= '$'+CONVERT(nvarchar,Cast((@Price/(1 * @Units))as decimal(10,2)), 110) + '\Ft.' --Inch

  ELSE IF @Meaasure=23  SET @RET= '$'+CONVERT(nvarchar,Cast((@Price/(1 * @Units))as decimal(10,2)), 110) + '\Pk.' --Pk  
  ELSE SET @RET= ''
  return @ret
end
GO
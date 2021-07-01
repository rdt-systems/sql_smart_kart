SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SP_CanDeleteManufacturer]
(@ID uniqueidentifier)

as
if (select Count(1) from dbo.ItemMainView
          where ManufacturerID=@ID AND Status>-1)=0
                   select 1
else
                   select 0
GO
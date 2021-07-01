SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SP_IsUseTagAlong]
(@ID uniqueidentifier)

as
if (select Count(1) from dbo.ItemStore
          where (ExtraCharge1=@ID OR ExtraCharge2=@ID OR ExtraCharge3=@ID) AND Status>-1)=0
                   select 1
else
                   select 0
GO
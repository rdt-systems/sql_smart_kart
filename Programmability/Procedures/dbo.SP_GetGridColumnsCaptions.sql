SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE procedure [dbo].[SP_GetGridColumnsCaptions]

as 
select GridNumber,FieldName,FieldCaption,FieldCaptionHe
from  dbo.GridColumnsCaptions
GO
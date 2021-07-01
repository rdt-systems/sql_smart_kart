SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SP_GetItemDetailsFilterView]
(@DeletedOnly bit =0,
@DateModified datetime=null)
AS

select ItemDetailsFilterView.*
from  ItemDetailsFilterView
GO
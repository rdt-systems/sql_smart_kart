SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SP_GetCreditSlipView]
(@DeletedOnly bit =0,
@DateModified datetime=null)
AS


if @DateModified is null 
begin
   SELECT     dbo.CreditSlipView.*
   FROM         dbo.CreditSlipView
   WHERE     (Status > - 1)

 return
end


if  @DeletedOnly=0 
	 SELECT     dbo.CreditSlipView.*
         FROM         dbo.CreditSlipView
	WHERE     (DateModified>@DateModified)  AND 
	(Status > - 1)

else
	 SELECT     dbo.CreditSlipView.*
         FROM         dbo.CreditSlipView
	WHERE    (DateModified>@DateModified)   AND 
		 (Status = - 1)
GO
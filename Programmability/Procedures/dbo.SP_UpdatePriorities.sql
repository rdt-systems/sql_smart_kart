SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE proc [dbo].[SP_UpdatePriorities](@SaleID uniqueidentifier)
as

declare @Pr int
if (select Count(*) from Sales Where Priority=0)>0 
  update Sales Set Priority=Priority+1
 
Set @Pr= (Select min(Priority) From Sales s Where exists 
                 (Select 1 From Sales Where Priority= s.Priority and SaleID<>s.SaleID))
if @Pr=0 
  return

update Sales Set Priority=Priority+1
where Priority>=@Pr and SaleID<>@SaleID
GO
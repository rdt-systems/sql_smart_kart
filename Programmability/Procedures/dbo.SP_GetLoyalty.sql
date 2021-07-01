SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE procedure [dbo].[SP_GetLoyalty]
(@Filter nvarchar(4000))
as

declare  @MySelect nvarchar(4000)

set @MySelect= 'select  isnull(sum(AvailPoints),0)as  AvailPoints , isNull(sum(case when Points>0 then Points else 0 end ),0) as SumPoints , isNull(sum(case when Points<0 then Points else 0 end ),0) as RedeemedPoints  , isnull(sum(case when Points<0 then 1 else 0 end),0)as countRedeemed, max(case when Points<0 then DateCreated else null end) as LastDateRedeemed
		FROM dbo.Loyalty
		WHERE Status > 0  '


Execute (@MySelect + @Filter )
GO
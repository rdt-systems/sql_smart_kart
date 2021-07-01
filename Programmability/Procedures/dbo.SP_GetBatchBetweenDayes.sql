SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


Create PROCEDURE [dbo].[SP_GetBatchBetweenDayes]
(@FromDate datetime,
@ToDate datetime)
as

select * From Batch
where OpeningDateTime>=@FromDate and OpeningDateTime<@ToDate
GO
SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SP_SalesTypeDelete]
(@SaleTenderId uniqueidentifier,
 @SaleConditionNo uniqueidentifier,
@ModifierID uniqueidentifier)
AS

--UPDATE    dbo.SaleTenderType
--SET       Status =  - 1
--WHERE	SaleTenderId = @SaleTenderId 

UPDATE  dbo.Sales
SET	DateModified = dbo.GetLocalDATE(),
	UserModified = @ModifierID
WHERE	SaleConditionsNo=@SaleConditionNo
GO
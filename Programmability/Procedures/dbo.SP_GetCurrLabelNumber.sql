SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SP_GetCurrLabelNumber]
(
@StoreNo uniqueidentifier
)

AS

	DECLARE @LabelDate datetime
	SET @LabelDate=(SELECT OptionValue from SetUpValues WHERE OptionName='Label Date' and StoreID=@StoreNo)
	
	DECLARE @Date datetime
	SET @Date=dbo.GetLocalDATE()
	
	IF 	 CONVERT(VARCHAR,@LabelDate,111)	=CONVERT(VARCHAR,@date,111)
		BEGIN
			UPDATE SetUpValues SET OptionValue=OptionValue+1 WHERE OptionName='Label Number'  and StoreID=@StoreNo
			SELECT OptionValue from SetUpValues WHERE OptionName='Label Number'  and StoreID=@StoreNo
		END
	ELSE
		BEGIN
			UPDATE SetUpValues SET OptionValue=0 WHERE OptionName='Label Number'  and StoreID=@StoreNo
			UPDATE SetUpValues SET OptionValue=@Date WHERE OptionName='Label Date'  and StoreID=@StoreNo
			SELECT 0
		END
GO
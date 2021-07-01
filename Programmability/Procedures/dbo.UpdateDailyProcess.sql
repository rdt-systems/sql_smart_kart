SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE procedure [dbo].[UpdateDailyProcess]
as

DECLARE @UD_Customer as bit
DECLARE @UD_OnHand as bit
DECLARE @UD_PTD as bit

--IF (Select Top(1)OptionValue FROM SETUPVALUES WHERE OPTIONID = 45)IS NOT NULL 
   SET @UD_Customer = (Select Top(1)IsNull(OptionValue,0) FROM SETUPVALUES WHERE OPTIONID = 45)
--ELSE
--  SET @UD_Customer = 0
if @UD_Customer = 1 
  Exec dbo.DailyUpdate

--IF (Select Top(1)OptionValue FROM SETUPVALUES WHERE OPTIONID = 46)IS NOT NULL 
   SET @UD_OnHand = (Select Top(1)IsNull(OptionValue,0) FROM SETUPVALUES WHERE OPTIONID = 46)
--ELSE BEGIN
--  SET @UD_OnHand = 1
--END
If @UD_OnHand = 1
BEGIN 
  Exec dbo.OnHandUpdate
END
--Exec dbo.UpdateTempItemsSales


IF (Select Top(1)OptionValue FROM SETUPVALUES WHERE OPTIONID = 47)IS NOT NULL 
   SET @UD_PTD = (Select Top(1)OptionValue FROM SETUPVALUES WHERE OPTIONID = 47)
ELSE
  SET @UD_PTD = 0
IF @UD_PTD = 1 
BEGIN

	DECLARE @ID uniqueidentifier

	DECLARE c1 CURSOR FORWARD_ONLY STATIC OPTIMISTIC FOR
	SELECT StoreID
	FROM   dbo.Store 
	WHERE  Status>0

	OPEN c1

	FETCH NEXT FROM c1 
	INTO @ID

	WHILE @@FETCH_STATUS = 0
		BEGIN
			Exec dbo.UpdateMYPTD @ID

			FETCH NEXT FROM c1  
			INTO @ID
		END

	CLOSE c1
	DEALLOCATE c1
END
GO
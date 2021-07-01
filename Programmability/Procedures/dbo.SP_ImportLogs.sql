SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SP_ImportLogs]
AS
delete sqlimportlog where errors like 'Violation of PRIMARY KEY%' OR query Like '' OR query Like '%UpdatePointAPIBalance%' OR query like '%PosLogs%'

DECLARE @Q VARCHAR(4000), @id int, @Error nvarchar(500),  @iError int

DECLARE B CURSOR  FOR Select id, query from SQLImportLog

OPEN B

FETCH NEXT FROM B INTO @id, @Q

WHILE @@FETCH_STATUS = 0
BEGIN
BEGIN TRY
EXEC (@Q)
END TRY
BEGIN CATCH
Select @Error = ERROR_MESSAGE();
END CATCH

if @Error is not null
update SQLImportLog Set errors = @Error Where id = @id
if @Error like 'Violation of PRIMARY KEY%'
Delete From SQLImportLog Where id = @id

if @Error is null
Delete From SQLImportLog Where id = @id



FETCH NEXT FROM B INTO @id, @Q
END


CLOSE B

DEALLOCATE B
GO
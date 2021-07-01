SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE Procedure [dbo].[RunDBUpdates] 
as

DECLARE @UpdateText varchar(8000)

DECLARE cUpdates CURSOR FORWARD_ONLY STATIC OPTIMISTIC FOR
select [UpdateText] 
from DBUpdates 
where [status]>0
and Version>=(select top 1 Version From DBVersion Order By VersionDate)
order by Version,Sort,DateCreated

OPEN cUpdates

FETCH NEXT FROM cUpdates
INTO @UpdateText

WHILE @@FETCH_STATUS = 0
	BEGIN

		Exec (@UpdateText )

		FETCH NEXT FROM cUpdates   
		INTO @UpdateText

	END

CLOSE cUpdates
DEALLOCATE cUpdates
GO
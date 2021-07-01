SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE    proc [dbo].[SP_GET_COMP_UPDATE_PATH]
    @CompName nvarchar(50) 

as
declare @UpdatePath varchar(50)
select @UpdatePath=CompDBUpdatePath from dbo.CompSettings
where CompName=@CompName

select @UpdatePath
GO
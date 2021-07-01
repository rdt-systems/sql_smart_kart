SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


create PROCEDURE [dbo].[WEB_UpdateResellerDesign] 
( @ResellerID uniqueidentifier,
 @Design smallint)
AS
	
update resellers 
set 
DesignID=@Design
where resellerid=@ResellerID
and status>0
GO
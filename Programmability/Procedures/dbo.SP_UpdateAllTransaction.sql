SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


create procedure [dbo].[SP_UpdateAllTransaction] as


update 	Tender 
set 	DateModified=DateModified

update 	Tax 
set 	DateModified=DateModified
GO
SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SP_SeasonUpdate]

(@SeasonId uniqueidentifier,
@Name nvarchar(50),
@Description nvarchar(4000),
@StartDate datetime,
@EndDate datetime,
@Status smallint,
@DateModified datetime,
@ModifierID uniqueidentifier)

AS 

Declare @UpdateTime datetime
set  @UpdateTime =dbo.GetLocalDATE()


UPDATE  dbo.Season
                      SET    Name = @Name, Description = @Description, 
                                 
                                 StartDate=@StartDate,
	        	 EndDate=@EndDate,
		 Status = @Status ,
		 DateModified =@UpdateTime,
		 UserModified =@ModifierID

WHERE  (SeasonId = @SeasonId) and  (DateModified = @DateModified or DateModified is NULL)


select @UpdateTime as DateModified
GO
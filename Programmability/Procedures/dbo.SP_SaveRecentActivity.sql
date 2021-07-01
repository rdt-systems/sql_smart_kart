SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SP_SaveRecentActivity]
(
	
@ActivityType int ,
@TableName nvarchar(100),
@Status int,
@TableID  nvarchar(100),
@IsGuid bit,
@FieldName nvarchar(100),
@UserId uniqueidentifier,
@AdditionalInfo nvarchar(500)
)

AS
BEGIN


insert into	RecentActivity(
ActivityType,
TableName,
Status,
TableID,
DateModified,
IsGuid,
FieldName,
UserId,
AdditionalInfo)
values(
@ActivityType  ,
@TableName ,
@Status ,
@TableID ,
dbo.GetLocalDate() ,
@IsGuid ,
@FieldName ,
@UserId ,
@AdditionalInfo

)
END
GO
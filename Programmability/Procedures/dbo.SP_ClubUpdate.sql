SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SP_ClubUpdate]
(@ClubID nvarchar(50),
@ClubName uniqueidentifier,
@StoreID nvarchar(50),
@Status smallint,
@ModifierID uniqueidentifier)
AS 

Declare @UpdateTime datetime
set  @UpdateTime =dbo.GetLocalDATE()


UPDATE dbo.Club

                   SET      ClubName=dbo.CheckString(@ClubName), StoreID=@StoreID,Status=@Status,DateModified=@UpdateTime

WHERE  ClubID=@ClubID

select @UpdateTime as DateModified
GO
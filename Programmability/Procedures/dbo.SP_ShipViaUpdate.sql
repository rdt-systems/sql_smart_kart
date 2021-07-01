SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SP_ShipViaUpdate]
(@ShipViaID uniqueidentifier,
@ShipViaName nvarchar(50),
@status smallint,
@DateModified datetime,
@ModifierId uniqueidentifier)
As

Declare @UpdateTime datetime
set  @UpdateTime =dbo.GetLocalDATE()

Update dbo.ShipVia

 SET       ShipViaName =@ShipViaName,   ShipViaID=@ShipViaID, status = @status,  DateModified = @UpdateTime, UserModified=@ModifierId

WHERE (ShipViaID = @ShipViaID) and  (DateModified = @DateModified or DateModified is NULL)

select @UpdateTime as DateModified
GO
SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SP_ManufacturersUpdate]
(@ManufacturerID uniqueidentifier,
@ManufacturerName nvarchar(50),
@Status smallint,
@DateModified datetime,
@ModifierID uniqueidentifier)
AS

Declare @UpdateTime datetime
set  @UpdateTime =dbo.GetLocalDATE()

 UPDATE dbo.Manufacturers

SET	ManufacturerName=dbo.CheckString(@ManufacturerName),
	Status=@Status,
	DateModified=@UpdateTime,
	UserModified=@ModifierID

WHERE	(ManufacturerID=@ManufacturerID) AND 
      (DateModified = @DateModified OR DateModified IS NULL)



select @UpdateTime as DateModified
GO
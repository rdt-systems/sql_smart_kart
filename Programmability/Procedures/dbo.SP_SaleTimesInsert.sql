SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SP_SaleTimesInsert]

(
@SaleTimeID	uniqueidentifier,	
@SaleID	uniqueidentifier,	
@Sunday	bit,	
@SunFrom	datetime,	
@SunTo	datetime,	
@Munday	bit,	
@MunFrom	datetime,
@MunTo	datetime,	
@Tuesday	bit,	
@TueFrom	datetime,	
@TueTo	datetime,	
@Wednesday	bit,	
@WedFrom	datetime,	
@WedTo	datetime,	
@Thursday	bit,	
@ThuFrom	datetime,	
@ThuTo	datetime,	
@Friday	bit	,
@FriFrom	datetime,	
@FriTo	datetime,	
@Saterday	bit,	
@SatFrom	datetime,	
@SatTo	datetime,	
@Status	smallint,	
@ModifierID uniqueidentifier)

AS

INSERT INTO dbo.SaleTimes
       (
	SaleTimeID,SaleID,Sunday,SunFrom,SunTo,Munday,MunFrom,MunTo,Tuesday,TueFrom,TueTo,
Wednesday,WedFrom,WedTo,Thursday,ThuFrom,ThuTo,Friday,FriFrom,FriTo,Saterday,SatFrom,
SatTo,	Status,DateCreated,UserCreated,DateModified,UserModified		
		)

VALUES  (
	   @SaleTimeID,@SaleID,@Sunday,@SunFrom,@SunTo,@Munday,@MunFrom,@MunTo,@Tuesday,@TueFrom,@TueTo,
@Wednesday,@WedFrom,@WedTo,@Thursday,@ThuFrom,@ThuTo,@Friday,@FriFrom,@FriTo,@Saterday,@SatFrom,
@SatTo,
		1,dbo.GetLocalDATE(),@ModifierID,dbo.GetLocalDATE(),@ModifierID
		)
GO
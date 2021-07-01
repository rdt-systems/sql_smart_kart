SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SP_SaleTimesUpdate]
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
@DateModified datetime,	
@ModifierID uniqueidentifier
)
AS

Declare @UpdateTime datetime
set  @UpdateTime =dbo.GetLocalDATE()

UPDATE    dbo.SaleTimes
SET           	
SaleID=@SaleID,
Sunday=@Sunday,	
SunFrom=@SunFrom,		
SunTo=@SunTo,	
Munday=@Munday,	
MunFrom=@MunFrom,		
MunTo=@MunTo,		
Tuesday=@Tuesday,	
TueFrom=@TueFrom,		
TueTo=@TueTo,	
Wednesday=@Wednesday,	
WedFrom=@WedFrom,		
WedTo=@WedTo,	
Thursday=@Thursday,		
ThuFrom=@ThuFrom,		
ThuTo=@ThuTo,	
Friday=@Friday,	
FriFrom=@FriFrom,		
FriTo=@FriTo	,
Saterday=@Saterday,		
SatFrom=@SatFrom,	
SatTo=@SatTo,		
Status=@Status,
DateModified=@UpdateTime,
UserModified = @ModifierID	
                    
WHERE     
(SaleTimeID = @SaleTimeID) AND 
(DateModified = @DateModified OR DateModified IS NULL)

select @UpdateTime as DateModified
GO
SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SP_LookAccountUpdate]
(@LookAccountID uniqueidentifier,
@CustomerID nvarchar(50),
@DaysOver nvarchar(50),
@Ammount money,
@Status smallint,
@DateModified datetime,
@ModifierID uniqueidentifier)
AS 

Declare @UpdateTime datetime
set  @UpdateTime =dbo.GetLocalDATE()

UPDATE  dbo.LookAccount


                 SET  CustomerID= @CustomerID, DaysOver= @DaysOver, Ammount= @Ammount, Status=@Status, DateModified= @UpdateTime, 

UserModified=@ModifierID

WHERE (LookAccountID=@LookAccountID) AND 
      (DateModified = @DateModified OR DateModified IS NULL)


select @UpdateTime as DateModified
GO
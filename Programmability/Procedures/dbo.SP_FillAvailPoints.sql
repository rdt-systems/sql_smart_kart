SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SP_FillAvailPoints]
(@Points int,
@CustomerID uniqueidentifier,
@Weekly Int=0
)
AS	




if @weekly = 1 
		update dbo.Loyalty SET AvailPoints= 0 where DateCreated <(dbo.GetFirstDayOfWeek(dbo.GetLocalDATE(),1))
		and CustomerID=@CustomerID
else begin
		declare @minus int
		set @minus =0
		update dbo.Loyalty
		set @Points=@Points-@minus, 
			AvailPoints=case when @Points>ISNULL(AvailPoints,Points) then 0 else ISNULL(AvailPoints,Points)-@Points end,
			@minus=case when @Points>ISNULL(AvailPoints,Points) then ISNULL(AvailPoints,Points) else @Points end
		WHERE  CustomerID=@CustomerID and ISNULL(AvailPoints,0)>=0 and Status>0
	end
GO
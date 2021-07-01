SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SP_FeelAvailPoints]
(@Points int,
@CustomerID uniqueidentifier)

AS

	declare @minus int
	set @minus =0

	update dbo.Loyalty
	set @Points=@Points-@minus, 
		AvailPoints=case when @Points>ISNULL(AvailPoints,Points) then 0 else ISNULL(AvailPoints,Points)-@Points end,
		@minus=case when @Points>ISNULL(AvailPoints,Points) then ISNULL(AvailPoints,Points) else @Points end
	WHERE CustomerID=@CustomerID
GO
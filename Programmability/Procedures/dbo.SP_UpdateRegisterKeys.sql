SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO



CREATE PROCEDURE [dbo].[SP_UpdateRegisterKeys]
as
 
Delete from RegisterKeys where [ActionID] is null
--drop table #temp
select 1 [RegisterKeyID],cast('1' as nvarchar(50)) [ActionID],cast('1' as nvarchar(50))[ActionKey],0[ShiftType],1[IsAction],1[IsButton],1[Status],dbo.GetLocalDATE()[DateCreated],dbo.GetLocalDATE()[DateModified],N'00000000-0000-0000-0000-000000000000'[UserModified] INTO #temp 
INSERT INTO #temp([RegisterKeyID],[ActionID],[ActionKey],[ShiftType],[IsAction],[IsButton],[Status],[DateCreated] ,[DateModified],[UserModified]) VALUES (2,N'2',N'2',0,1,1,1,dbo.GetLocalDATE(),dbo.GetLocalDATE(),N'00000000-0000-0000-0000-000000000000')
INSERT INTO #temp([RegisterKeyID],[ActionID],[ActionKey],[ShiftType],[IsAction],[IsButton],[Status],[DateCreated] ,[DateModified],[UserModified]) VALUES (3,N'3',N'3',0,1,1,1,dbo.GetLocalDATE(),dbo.GetLocalDATE(),N'00000000-0000-0000-0000-000000000000')
INSERT INTO #temp([RegisterKeyID],[ActionID],[ActionKey],[ShiftType],[IsAction],[IsButton],[Status],[DateCreated] ,[DateModified],[UserModified]) VALUES (4,N'4',N'4',0,1,1,1,dbo.GetLocalDATE(),dbo.GetLocalDATE(),N'00000000-0000-0000-0000-000000000000')
INSERT INTO #temp([RegisterKeyID],[ActionID],[ActionKey],[ShiftType],[IsAction],[IsButton],[Status],[DateCreated] ,[DateModified],[UserModified]) VALUES (5,N'5',N'5',0,1,1,1,dbo.GetLocalDATE(),dbo.GetLocalDATE(),N'00000000-0000-0000-0000-000000000000')
INSERT INTO #temp([RegisterKeyID],[ActionID],[ActionKey],[ShiftType],[IsAction],[IsButton],[Status],[DateCreated] ,[DateModified],[UserModified]) VALUES (6,N'6',N'6',0,1,1,1,dbo.GetLocalDATE(),dbo.GetLocalDATE(),N'00000000-0000-0000-0000-000000000000')
INSERT INTO #temp([RegisterKeyID],[ActionID],[ActionKey],[ShiftType],[IsAction],[IsButton],[Status],[DateCreated] ,[DateModified],[UserModified]) VALUES (7,N'7',N'7',0,1,1,1,dbo.GetLocalDATE(),dbo.GetLocalDATE(),N'00000000-0000-0000-0000-000000000000')
INSERT INTO #temp([RegisterKeyID],[ActionID],[ActionKey],[ShiftType],[IsAction],[IsButton],[Status],[DateCreated] ,[DateModified],[UserModified]) VALUES (8,N'8',N'8',0,1,1,1,dbo.GetLocalDATE(),dbo.GetLocalDATE(),N'00000000-0000-0000-0000-000000000000')
INSERT INTO #temp([RegisterKeyID],[ActionID],[ActionKey],[ShiftType],[IsAction],[IsButton],[Status],[DateCreated] ,[DateModified],[UserModified]) VALUES (9,N'9',N'9',0,1,1,1,dbo.GetLocalDATE(),dbo.GetLocalDATE(),N'00000000-0000-0000-0000-000000000000')
INSERT INTO #temp([RegisterKeyID],[ActionID],[ActionKey],[ShiftType],[IsAction],[IsButton],[Status],[DateCreated] ,[DateModified],[UserModified]) VALUES (10,N'10',N'10',0,1,1,1,dbo.GetLocalDATE(),dbo.GetLocalDATE(),N'00000000-0000-0000-0000-000000000000')
INSERT INTO #temp([RegisterKeyID],[ActionID],[ActionKey],[ShiftType],[IsAction],[IsButton],[Status],[DateCreated] ,[DateModified],[UserModified]) VALUES (11,N'11',N'11',0,1,1,1,dbo.GetLocalDATE(),dbo.GetLocalDATE(),N'00000000-0000-0000-0000-000000000000')
INSERT INTO #temp([RegisterKeyID],[ActionID],[ActionKey],[ShiftType],[IsAction],[IsButton],[Status],[DateCreated] ,[DateModified],[UserModified]) VALUES (12,N'12',N'12',0,1,1,1,dbo.GetLocalDATE(),dbo.GetLocalDATE(),N'00000000-0000-0000-0000-000000000000')
INSERT INTO #temp([RegisterKeyID],[ActionID],[ActionKey],[ShiftType],[IsAction],[IsButton],[Status],[DateCreated] ,[DateModified],[UserModified]) VALUES (13,N'13',N'1',1,1,1,1,dbo.GetLocalDATE(),dbo.GetLocalDATE(),N'00000000-0000-0000-0000-000000000000')
INSERT INTO #temp([RegisterKeyID],[ActionID],[ActionKey],[ShiftType],[IsAction],[IsButton],[Status],[DateCreated] ,[DateModified],[UserModified]) VALUES (14,N'15',N'3',1,1,1,1,dbo.GetLocalDATE(),dbo.GetLocalDATE(),N'00000000-0000-0000-0000-000000000000')
INSERT INTO #temp([RegisterKeyID],[ActionID],[ActionKey],[ShiftType],[IsAction],[IsButton],[Status],[DateCreated] ,[DateModified],[UserModified]) VALUES (15,N'23',N'11',1,1,1,1,dbo.GetLocalDATE(),dbo.GetLocalDATE(),N'00000000-0000-0000-0000-000000000000')
INSERT INTO #temp([RegisterKeyID],[ActionID],[ActionKey],[ShiftType],[IsAction],[IsButton],[Status],[DateCreated] ,[DateModified],[UserModified]) VALUES (16,N'24',N'12',1,1,1,1,dbo.GetLocalDATE(),dbo.GetLocalDATE(),N'00000000-0000-0000-0000-000000000000')
INSERT INTO #temp([RegisterKeyID],[ActionID],[ActionKey],[ShiftType],[IsAction],[IsButton],[Status],[DateCreated] ,[DateModified],[UserModified]) VALUES (17,N'25',N'1',2,1,1,1,dbo.GetLocalDATE(),dbo.GetLocalDATE(),N'00000000-0000-0000-0000-000000000000')
INSERT INTO #temp([RegisterKeyID],[ActionID],[ActionKey],[ShiftType],[IsAction],[IsButton],[Status],[DateCreated] ,[DateModified],[UserModified]) VALUES (18,N'26',N'2',2,1,1,1,dbo.GetLocalDATE(),dbo.GetLocalDATE(),N'00000000-0000-0000-0000-000000000000')
INSERT INTO #temp([RegisterKeyID],[ActionID],[ActionKey],[ShiftType],[IsAction],[IsButton],[Status],[DateCreated] ,[DateModified],[UserModified]) VALUES (19,N'27',N'3',2,1,1,1,dbo.GetLocalDATE(),dbo.GetLocalDATE(),N'00000000-0000-0000-0000-000000000000')
INSERT INTO #temp([RegisterKeyID],[ActionID],[ActionKey],[ShiftType],[IsAction],[IsButton],[Status],[DateCreated] ,[DateModified],[UserModified]) VALUES (20,N'28',N'4',2,1,1,1,dbo.GetLocalDATE(),dbo.GetLocalDATE(),N'00000000-0000-0000-0000-000000000000')
INSERT INTO #temp([RegisterKeyID],[ActionID],[ActionKey],[ShiftType],[IsAction],[IsButton],[Status],[DateCreated] ,[DateModified],[UserModified]) VALUES (21,N'29',N'5',2,1,1,1,dbo.GetLocalDATE(),dbo.GetLocalDATE(),N'00000000-0000-0000-0000-000000000000')
INSERT INTO #temp([RegisterKeyID],[ActionID],[ActionKey],[ShiftType],[IsAction],[IsButton],[Status],[DateCreated] ,[DateModified],[UserModified]) VALUES (22,N'30',N'6',2,1,1,1,dbo.GetLocalDATE(),dbo.GetLocalDATE(),N'00000000-0000-0000-0000-000000000000')
INSERT INTO #temp([RegisterKeyID],[ActionID],[ActionKey],[ShiftType],[IsAction],[IsButton],[Status],[DateCreated] ,[DateModified],[UserModified]) VALUES (23,N'31',N'7',2,1,1,1,dbo.GetLocalDATE(),dbo.GetLocalDATE(),N'00000000-0000-0000-0000-000000000000')
INSERT INTO #temp([RegisterKeyID],[ActionID],[ActionKey],[ShiftType],[IsAction],[IsButton],[Status],[DateCreated] ,[DateModified],[UserModified]) VALUES (24,N'32',N'8',2,1,1,1,dbo.GetLocalDATE(),dbo.GetLocalDATE(),N'00000000-0000-0000-0000-000000000000')
INSERT INTO #temp([RegisterKeyID],[ActionID],[ActionKey],[ShiftType],[IsAction],[IsButton],[Status],[DateCreated] ,[DateModified],[UserModified]) VALUES (25,N'33',N'9',2,1,1,1,dbo.GetLocalDATE(),dbo.GetLocalDATE(),N'00000000-0000-0000-0000-000000000000')
INSERT INTO #temp([RegisterKeyID],[ActionID],[ActionKey],[ShiftType],[IsAction],[IsButton],[Status],[DateCreated] ,[DateModified],[UserModified]) VALUES (26,N'34',N'10',2,1,1,1,dbo.GetLocalDATE(),dbo.GetLocalDATE(),N'00000000-0000-0000-0000-000000000000')
INSERT INTO #temp([RegisterKeyID],[ActionID],[ActionKey],[ShiftType],[IsAction],[IsButton],[Status],[DateCreated] ,[DateModified],[UserModified]) VALUES (27,N'35',N'11',2,1,1,1,dbo.GetLocalDATE(),dbo.GetLocalDATE(),N'00000000-0000-0000-0000-000000000000')
INSERT INTO #temp([RegisterKeyID],[ActionID],[ActionKey],[ShiftType],[IsAction],[IsButton],[Status],[DateCreated] ,[DateModified],[UserModified]) VALUES (28,N'36',N'12',2,1,1,1,dbo.GetLocalDATE(),dbo.GetLocalDATE(),N'00000000-0000-0000-0000-000000000000')
INSERT INTO #temp([RegisterKeyID],[ActionID],[ActionKey],[ShiftType],[IsAction],[IsButton],[Status],[DateCreated] ,[DateModified],[UserModified]) VALUES (29,N'37',N'1',3,1,1,1,dbo.GetLocalDATE(),dbo.GetLocalDATE(),N'00000000-0000-0000-0000-000000000000')
INSERT INTO #temp([RegisterKeyID],[ActionID],[ActionKey],[ShiftType],[IsAction],[IsButton],[Status],[DateCreated] ,[DateModified],[UserModified]) VALUES (30,N'38',N'2',3,1,1,1,dbo.GetLocalDATE(),dbo.GetLocalDATE(),N'00000000-0000-0000-0000-000000000000')
INSERT INTO #temp([RegisterKeyID],[ActionID],[ActionKey],[ShiftType],[IsAction],[IsButton],[Status],[DateCreated] ,[DateModified],[UserModified]) VALUES (31,N'39',N'3',3,1,1,1,dbo.GetLocalDATE(),dbo.GetLocalDATE(),N'00000000-0000-0000-0000-000000000000')
INSERT INTO #temp([RegisterKeyID],[ActionID],[ActionKey],[ShiftType],[IsAction],[IsButton],[Status],[DateCreated] ,[DateModified],[UserModified]) VALUES (32,N'41',N'5',3,1,1,1,dbo.GetLocalDATE(),dbo.GetLocalDATE(),N'00000000-0000-0000-0000-000000000000')
INSERT INTO #temp([RegisterKeyID],[ActionID],[ActionKey],[ShiftType],[IsAction],[IsButton],[Status],[DateCreated] ,[DateModified],[UserModified]) VALUES (33,N'42',N'6',3,1,1,1,dbo.GetLocalDATE(),dbo.GetLocalDATE(),N'00000000-0000-0000-0000-000000000000')
INSERT INTO #temp([RegisterKeyID],[ActionID],[ActionKey],[ShiftType],[IsAction],[IsButton],[Status],[DateCreated] ,[DateModified],[UserModified]) VALUES (34,N'43',N'7',3,1,1,1,dbo.GetLocalDATE(),dbo.GetLocalDATE(),N'00000000-0000-0000-0000-000000000000')
INSERT INTO #temp([RegisterKeyID],[ActionID],[ActionKey],[ShiftType],[IsAction],[IsButton],[Status],[DateCreated] ,[DateModified],[UserModified]) VALUES (35,N'44',N'4',1,1,1,1,dbo.GetLocalDATE(),dbo.GetLocalDATE(),N'00000000-0000-0000-0000-000000000000')
INSERT INTO #temp([RegisterKeyID],[ActionID],[ActionKey],[ShiftType],[IsAction],[IsButton],[Status],[DateCreated] ,[DateModified],[UserModified]) VALUES (36,N'45',N'5',1,1,1,1,dbo.GetLocalDATE(),dbo.GetLocalDATE(),N'00000000-0000-0000-0000-000000000000')
INSERT INTO #temp([RegisterKeyID],[ActionID],[ActionKey],[ShiftType],[IsAction],[IsButton],[Status],[DateCreated] ,[DateModified],[UserModified]) VALUES (37,N'46',N'6',1,1,1,1,dbo.GetLocalDATE(),dbo.GetLocalDATE(),N'00000000-0000-0000-0000-000000000000')

insert into registerKeys([RegisterKeyID],[ActionID],[ActionKey],[ShiftType],[IsAction],[IsButton],[Status],[DateCreated] ,[DateModified],[UserModified])
(select (SELECT Isnull(MAX([RegisterKeyID]),0)  +#temp.[RegisterKeyID]  FROM registerKeys),[ActionID],[ActionKey],[ShiftType],[IsAction],[IsButton],[Status],[DateCreated] ,[DateModified],[UserModified]
From #temp
WHERE not exists (SELECT 1 FROM registerKeys r WHERE (r.[ActionID] collate Hebrew_CI_AS=#temp.[ActionID] collate Hebrew_CI_AS) or (r.actionKey collate Hebrew_CI_AS =#temp.actionKey collate Hebrew_CI_AS and r.[ShiftType] =#temp.[ShiftType] )))

select cast('1' as nvarchar(50))[ActionKey],0 as ShiftType into #temp1
insert into #temp1 values('2',0)
insert into #temp1 values('3',0)
insert into #temp1 values('4',0)
insert into #temp1 values('5',0)
insert into #temp1 values('6',0)
insert into #temp1 values('7',0)
insert into #temp1 values('8',0)
insert into #temp1 values('9',0)
insert into #temp1 values('10',0)
insert into #temp1 values('11',0)
insert into #temp1 values('12',0)
insert into #temp1 values('1',1)
insert into #temp1 values('2',1)
insert into #temp1 values('3',1)
insert into #temp1 values('4',1)
insert into #temp1 values('5',1)
insert into #temp1 values('6',1)
insert into #temp1 values('7',1)
insert into #temp1 values('8',1)
insert into #temp1 values('9',1)
insert into #temp1 values('10',1)
insert into #temp1 values('11',1)
insert into #temp1 values('12',1)
insert into #temp1 values('1',2)
insert into #temp1 values('2',2)
insert into #temp1 values('3',2)
insert into #temp1 values('4',2)
insert into #temp1 values('5',2)
insert into #temp1 values('6',2)
insert into #temp1 values('7',2)
insert into #temp1 values('8',2)
insert into #temp1 values('9',2)
insert into #temp1 values('10',2)
insert into #temp1 values('11',2)
insert into #temp1 values('12',2)
insert into #temp1 values('1',3)
insert into #temp1 values('2',3)
insert into #temp1 values('3',3)
insert into #temp1 values('4',3)
insert into #temp1 values('5',3)
insert into #temp1 values('6',3)
insert into #temp1 values('7',3)
insert into #temp1 values('8',3)
insert into #temp1 values('9',3)
insert into #temp1 values('10',3)
insert into #temp1 values('11',3)
insert into #temp1 values('12',3)

Select Row_Number() over(order By [ShiftType])row,* into #temp2 From #temp1 Where 
not exists (SELECT 1 FROM registerKeys r WHERE (r.actionKey collate Hebrew_CI_AS=#temp1.actionKey collate Hebrew_CI_AS and r.[ShiftType]  =#temp1.[ShiftType] ))

insert into registerKeys([RegisterKeyID],[ActionID],[ActionKey],[ShiftType],[IsAction],[IsButton],[Status],[DateCreated] ,[DateModified],[UserModified])
(select (SELECT Isnull(MAX([RegisterKeyID]),0)+Source.row FROM registerKeys),[ActionID],
(SELECT Top 1 [ActionKey] From #temp2 Where row=Source.row),
(SELECT Top 1 [ShiftType] From #temp2 Where row=Source.row),
[IsAction],[IsButton],[Status],[DateCreated] ,[DateModified],[UserModified]
From (SELECT Row_Number() over(order By [RegisterKeyID])row,* From #temp WHERE 
	not exists (SELECT 1 FROM registerKeys r WHERE r.[ActionID] collate Hebrew_CI_AS=#temp.[ActionID] collate Hebrew_CI_AS)) as Source
Where Source.row<=(SELECT Count(*) from #temp2)
)

drop table #temp
drop table #temp1
drop table #temp2
GO
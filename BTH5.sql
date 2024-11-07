-- tính n!
declare @n int,@i int ,@res int
set @n = 4
set @i = 1
set @res = 1
while @i <= 5
begin
	set @res *= @i
	set @i += 1
end
print convert(varchar,@n) + ' giai thua la ' +convert(varchar,@res) 

-- ax2 + bx + c = 0
declare @a float,@b float ,@c float,@x1 float,@x2 float,@dental float
set @a = 0
set @b = 6
set @c = 1
set @x1 = 0
set @dental = (@b * @b) - 4 * @a *@c

if @a = 0 and @b <> 0
begin
	set @x1 = -@c / @b
	print 'pt tro thanh bac 1 co 1 nghiem la: ' + convert(varchar,@x1)
end
else if @a = 0 and @b = 0
begin
	if @c <> 0
		print 'vo nghiem'
	else if @c = 0
		print 'vo so nghiem'
end

else if @a <> 0 
begin
	set @x1 = (-@b + SQRT(@dental)) / (2 * @a)
	set @x2 = (-@b - SQRT(@dental)) / (2 * @a)
	print @x1
	print @x2
end


-- chan le < n
declare @n int ,@i int, @reschan int ,@resle int
set @n = 10
set @i = 0
set @reschan = 0
set @resle = 0

while @i < @n
begin
	if @i % 2 = 0
		begin
			set @reschan += @i
		end
	else
		begin
			set @resle += @i
		end
	set @i += 1
end

print @reschan
print @resle

-- cau a
select AVG(Students.Age) as AgeTb
from Students

-- cau b
select Students.Name, count(StudentTest.Date) as SoNgayDaThi
from Students
join StudentTest on Students.RN = StudentTest.RN
group by Students.Name

-- cau c
select Students.*, StudentTest.TestID,StudentTest.Mark
from Students
join StudentTest on Students.RN = StudentTest.RN
where StudentTest.Mark >= 4

-- cau d
select Students.Name,FORMAT(StudentTest.Mark,'N2') as Diem
from Students
left join StudentTest on Students.RN = StudentTest.RN

-- cau e
select Students.Name, Test.Name,StudentTest.Mark,StudentTest.Date
from Students
join StudentTest on Students.RN = StudentTest.RN
join Test on StudentTest.TestID = Test.testID


-- cau f
select * from Students
where Students.RN not in (select StudentTest.RN from StudentTest)


-- cau g
select Students.Name, AVG(StudentTest.Mark)
from Students
Join StudentTest on Students.RN = StudentTest.RN
group by Students.Name
order by AVG(StudentTest.Mark) desc


-- cau h
select top 1 Students.Name, AVG(StudentTest.Mark)
from Students
Join StudentTest on Students.RN = StudentTest.RN
group by Students.Name
order by AVG(StudentTest.Mark) desc

-- cau i
select Test.Name, max(StudentTest.Mark)
from Test
Join StudentTest on Test.testID = StudentTest.TestID
group by Test.Name

-- cau j
select Students.Name,Test.Name
from Students
left Join StudentTest on Students.RN = StudentTest.RN
left join Test on StudentTest.TestID = Test.testID


-- cau k
select Students.Name,count(
							case 
							when StudentTest.Mark < 4 then 1
							else null 
							end) as sl
from Students
left Join StudentTest on Students.RN = StudentTest.RN
left join Test on StudentTest.TestID = Test.testID
group by Students.Name


-- cau l
insert into Students (RN,Name,Age)
values (5,'Ho Kha Quy',20)

insert into StudentTest (RN,TestID,Date,Mark)
values (5,4,'2006-07-20',8.5)

insert into Test (testID,Name)
values (5,'CNTT')

select Students.*,StudentTest.*,Test.*
from Students
left join StudentTest on Students.RN = Students.RN
left join Test on StudentTest.TestID = Test.testID


-- cau m
delete from Students
where Name = N'Ho Kha Quy';

delete from Test
where testID = 5 

--cau n
update Students
set Age = Age + 1

select * from Students

-- cau o
alter table Students
Add Status varchar(10)

update Students
set Status = case
	when Age < 30 then 'Young'
	else 'Old'
end;
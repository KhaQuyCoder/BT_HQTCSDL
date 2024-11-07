-- Viết hàm dùng để lấy ra danh sách các học viên.
create function cau_a()
returns table
as
return (select * from Students)

select * from dbo.cau_a()

-- Viết hàm với tham số truyền vào là Họ, hàm dùng để lấy danh sách các học viên có họ
-- giống với họ truyền vào.

alter function cau_b(@ho varchar(50))
returns table
as
return (select * from Students where StudentName like  '%' + @ho)

select * from dbo.cau_b('An')
-- Viết hàm với tham số truyền vào là mã môn học, hàm dùng để lấy ra số học viên đăng
-- ký học môn học này.

create function cau_c(@maMH int)
returns int
as
begin
	return (select count(Marks.SubjectID) as soHocVienDK
			from Subjects 
			join Marks on Subjects.SubjectID = Marks.SubjectID
			where Marks.SubjectID = @maMH
			group by Subjects.SubjectID, SubjectName)
end

select dbo.cau_c(1)

--Viết hàm hiển thị danh sách và điểm của các học viên ứng với các môn học.

create function cau_d()
returns table
as
return (select Students.StudentID,StudentName,Age,Email,Marks.SubjectID,Mark
		from Students join Marks on Students.StudentID = Marks.StudentID) 

-- Viết hàm lấy ra số học viên hiện có.
create function cau_e()
returns int
as
begin
	return(select  count(StudentID) 
		   from Classstudent)
end

select dbo.cau_e() as soHocVien

-- Viết hàm với tham số truyền vào là tuổi 1 đến tuổi 2, hàm dùng để lấy ra danh sách các
-- học viên có độ tuổi từ tuổi 1 đến tuổi 2.

create function cau_f(@ageOne int, @ageTwo int)
returns table
as
return (select * from  Students 
		where Age >= @ageOne and Age <= @ageTwo)

select * from dbo.cau_f(20,25)

--Viết hàm tính điểm trung bình của các học viên
create function cau_g()
returns table
as

return (select Marks.StudentID, StudentName, AVG(CAST(Mark AS FLOAT)) as sss
	from Students 
	left join Marks on Students.StudentID = Marks.StudentID
	group by Marks.StudentID, StudentName)

select * from dbo.cau_g()


-- Viết hàm lấy ra điểm trung bình lớn nhất của các học viên

create function cau_h()
returns float
as
begin
	return (select top (1) with ties AVG(cast(mark as float)) as diem from Marks
			group by Marks.StudentID
			order by diem desc)
end

select dbo.cau_h()

-- Viết hàm hiển thị danh sách các học viên chưa thi môn nào.
create function cau_i()
returns table
as
return (select * from Students 
		where Students.StudentID not in (select StudentID from Marks))

select * from dbo.cau_i()


--Viết hàm với tham số truyền vào là điểm trung bình, hàm dùng để lấy ra danh sách các
-- học viên có điểm trung bình lớn hơn điểm trung bình truyền vào.
create function cau_j(@tb float)
returns table
as
return (select Students.StudentID,StudentName,AVG(CAST(Mark as float)) as tb
		from Students
		join Marks 
		on Students.StudentID = Marks.StudentID 
		group by Students.StudentID,StudentName
		having AVG(CAST(Mark as float)) >= @tb )

select * from dbo.cau_j(5)

-- Viết hàm lấy ra những sinh viên có điểm trung bình cao nhất.
create function cau_l()
returns table
as
return (select top 1 with ties Students.StudentID,StudentName,Age,Email, avg(cast(Mark as float)) as tb
		from Students 
		join Marks 
		on Students.StudentID = Marks.StudentID
		group by Students.StudentID,StudentName,Age,Email
		order by tb desc)
select * from dbo.cau_l()

-- Viết hàm dùng để thống kê mỗi môn học có bao nhiêu học viên đăng kí thi.
create function cau_m()
returns table
as
return (select SubjectID, count(StudentID) as so
		from Marks
		group by SubjectID)

select * from dbo.cau_m()

--Viết hàm với tham số truyền vào là SoSV, hãy lấy ra danh sách các môn học có số học
-- viên đăng ký thi là nhỏ hơn SoSV truyền vào.

create function cau_n(@soSV int)
returns table
as
return (select Subjects.SubjectID, Subjects.SubjectName,count(Subjects.SubjectID) as dk
		from Marks
		join Subjects 
		on Marks.SubjectID = Subjects.SubjectID
		group by Subjects.SubjectID,Subjects.SubjectName
		having count(Subjects.SubjectID) < @soSV)

select * from dbo.cau_n(4)


-- Viết hàm để lấy ra danh sách học viên cùng với điểm trung bình của các học viên. Nếu
-- học viên nào chưa có điểm thì ghi 0.

create function cau_o()
returns table
as
return (select Students.StudentID,StudentName,Age,Email,isnull(avg(cast(Mark as float)),0) as tb
		from Students
		left join Marks on Students.StudentID = Marks.StudentID
		group by  Students.StudentID,StudentName,Age,Email)

select * from dbo.cau_o()

--Giả sử điểm (mark) của sinh viên từ 0, 1, 2, …, 9, 10. Hãy viết hàm với tham số truyền
--vào là mã môn học, hàm dùng để thống kê mỗi mức điểm này có bao nhiêu sinh viên
-- trong môn học này. (Ví dụ: điểm 0 có 2 người, điểm 1 có 0 người, …, điểm 10 có 2
--người).

alter function cau_k(@maMH int)
returns table
as
return (select Mark, count(StudentID) as soSV
		from Marks
		where SubjectID = @maMH
		group by Mark
		)
select * from dbo.cau_k(3)
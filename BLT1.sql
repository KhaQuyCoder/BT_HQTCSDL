-- Dùng thủ tục

-- 1 Liệt kê tất cả các sinh viên, thông tin gồm tất cả các trường của bảng DMSV

create proc cau_1
as
	select * from DMSV

cau_1

-- 2 Liệt kê tất cả các sinh viên, thông tin gồm mã sv, tên sv, giới tính. Tên sịnh viên yêu
-- cầu viết hoa, sắp xếp tên sinh viên theo thứ tự giảm dần trong bảng chữ cái. ( sử dụng
 -- hàm UPPER và ORDER BY)

 create proc cau_2
 as
	select MaSV, UPPER(TenSV), Nam
	from DMSV
	order by TenSV desc

cau_2


-- 3 Liệt kê 2 sinh viên của khoa tin học: thông tin gồm: tên sv, giới tính. ( sử dụng TOP)

create proc cau_3
as
	select top 2 TenSV, Nam
	from DMSV
	where MaKH = 'CNTT'


cau_3

-- 4 Liệt kê 1 nửa số sinh viên trong bảng DMSV, thông tin gồm tất cả các trường của
-- bảng sinh viên. (sử dụng TOP)

alter proc cau_4
as
	select top(50) percent *
	from DMSV

cau_4

-- 5 Liệt kê sinh viên theo từng khoa, thông tin gồm: tên khoa, tên sinh viên. ( ORDER
-- BY)

create proc cau_5
as
	select *  
	from DMSV
	order by MaKH

cau_5

-- Tính điểm Trung bình của mỗi sinh viên.
create proc cau_15
as
	select MaSV, avg(Diem) as tb
	from KetQua
	group by MaSV

-- Đếm xem có bao nhiêu người đạt được điểm 8 của môn Lập trình C++
create proc cau_15
as
	select count(DMSV.MaSV) as sl
	from DMSV join KetQua on DMSV.MaSV = KetQua.MaSV 
			  join DMMH on KetQua.MaMH = DMMH.MaMH 	
	where TenMH = N'Lap trinh c++' and Diem = 9


-- 12 Liệt kê toàn bộ sinh viên và tổng số điếm của mỗi sinh viên, thông tin gồm: mã sinh
-- viên, tên sinh viên, tổng số điểm của từng sinh viên(SUM)
create proc cau_15
as
	select DMSV.MaSV,TenSV,sum(Diem)
	from DMSV join KetQua on DMSV.MaSV = KetQua.MaSV 
	group by DMSV.MaSV,TenSV

-- Thông kê có bao nhiêu sinh viên thi lại ở mỗi môn.

create proc cau_14
as
	select DMMH.MaMH,TenMH, COUNT(DMMH.MaMH) as soNguoiThiLai
	from KetQua join DMMH on KetQua.MaMH = DMMH.MaMH
	where Diem <= 9
	group by DMMH.MaMH,TenMH
--Liệt kê sinh viên có điểm thấp nhất của mỗi khoa. Thông tin gồm: mã khoa, tên
-- khoa, mã sinh viên, tên sinh viên, điểm thấp nhất (MIN)
create proc cau_10
as
	select DMKhoa.MaKH, DMKhoa.TenKH, DMSV.MaSV,TenSV,min(Diem)
	from DMKhoa join DMSV on DMKhoa.MaKH = DMSV.MaKH 
				join KetQua on DMSV.MaSV = KetQua.MaSV
	group by DMKhoa.MaKH, DMKhoa.TenKH, DMSV.MaSV,TenSV
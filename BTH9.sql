-- a. Viết thủ tục/hàm với tham số truyền vào là ngày A(dd/mm/yyyy), thủ tục/hàm dùng để
-- lấy danh sách các trận đấu diễn ra vào ngày ngày A, danh sách được sắp xếp theo
-- MaTD, Sân đấu.

-- THU TUC
alter proc cau_a	
	@date date
as
	select * from TranDau
	where Ngay = @date
	order by MaTD desc , SanDau asc

cau_a '2019-09-12'

-- HAM
create function cau_a_ham(@date date)
returns table
as
return (select * from TranDau
		where Ngay = @date
		order by MaTD asc , SanDau asc )


select * from dbo.cau_a_ham(2019-09-12)

--Viết thủ tục/ hàm với tham số truyền vào là tên A, thủ tục/hàm dùng để lấy ra danh sách
-- các cầu thủ có tên tương tự với tên A truyền vào này.

-- THU TUC
create proc cau_b
	@name varchar(50)
as
	select * from CauThu
	where TenCT like N'% '+@name+''
cau_b Son

-- HAM
create function cau_b_ham(@name varchar(50))
returns table
as
return (select * from CauThu where TenCT like '% '+@name+'')

select * from dbo.cau_b_ham(N'Son')

-- Tạo thủ tục/hàm có tham số truyền vào là MaTD. Thủ tục/hàm này dùng để lấy danh
-- sách các cầu thủ đã thi đấu trong trận đấu đó. Danh sách gồm có MaCT, TenCT, SoTrai

-- THU TUC
create proc cau_c
	@matd varchar(50)
as
	select CauThu.MaCT,TenCT,SoTran
	from ThamGia join CauThu on ThamGia.MaCT = CauThu.MaCT
	where ThamGia.MaTD = @matd
cau_c TD1

--  HAM
create function cau_c_ham(@matd varchar(50))
returns table
as
return (select CauThu.MaCT,TenCT,SoTran
		from ThamGia join CauThu on ThamGia.MaCT = CauThu.MaCT
		where ThamGia.MaTD = @matd)

select * from dbo.cau_c_ham('TD2')

-- Tạo thủ tục/hàm dùng để thống kê mỗi trọng tài đã điều khiển bao nhiêu trận đấu.

-- THU TUC
create proc cau_d
as
	select TrongTai, count(TrongTai) as sldk
	from TranDau
	group by TrongTai
cau_d

-- HAM
create function cau_d_ham()
returns table
as
return (select TrongTai, count(TrongTai) as sldk
		from TranDau
		group by TrongTai )
select * from dbo.cau_d_ham()

--Tạo thủ tục/hàm với tham số truyền vào là ngay1(dd/mm/yyyy) và
-- ngay2(dd/mm/yyyy), thủ tục/hàm dùng để thống kê số trận đấu của các đội bóng (làm
-- chủ nhà) đã thi đấu trong các ngày từ ngay1 đến ngay2.

-- THU TUC
alter proc cau_e
	@ngay1 date, @ngay2 date
as
	select DoiBong.MaDB 
	from DoiBong inner join TranDau  on DoiBong.MaDB = TranDau.MaDB1
				 inner join TranDau as db2 on  DoiBong.MaDB = TranDau.MaDB2 
	where Ngay >= @ngay1 and Ngay <= @ngay2

cau_e '2019-9-12', '2020-9-12'


--Viết thủ tục dùng để thêm mới 1 dòng dữ liệu vào bảng đội bóng, bảng cầu thủ, bảng
-- trận đấu, và bảng tham gia.
create proc cau_f
	@matd int,
	@tendb varchar(50),
	@maclb int
as
	insert into DoiBong
	values (@matd,@tendb,@maclb)
cau_f 8,VietNam, 8



--Viết thủ tục dùng để cập nhật dữ liệu của một cầu thủ, với thông tin cầu thủ là tham số
-- truyền vào và tham số @ketqua sẽ trả về chuỗi rỗng nếu cập nhật cầu thủ thành công,
-- ngược lại tham số này trả về chuỗi cho biết lý do không cập nhật được.

create proc cau_g
	@mact varchar(50), 
	@tenct varchar(50), 
	@madb int,
	@KetQua varchar(255) output
as
	if (not exists (select * from CauThu where MaCT = @mact))
		set @KetQua = N'ko ton tai ma ct trong he thong'
	else 
		begin
			begin try
				update CauThu
				set 
					TenCT = @tenct,
					MaDB = @madb
				where MaCT = @mact
				if @@ERROR <> 0
					set @KetQua = N'Lỗi cập nhật dữ liệu'
				else
					set @KetQua = N'Cập nhật thành công'
			end try
			begin catch
				set @KetQua = N'Lỗi cập nhật dữ liệu'
			end catch
		end
declare @ketqua varchar(255)
execute cau_g S1,N'Ho Kha Quy2', 1, @ketqua output


--Viết hàm với tham số truyền vào là năm, hàm dùng để lấy ra số trọng tài đã tham gia
-- điều khiển các trận đấu trong năm truyền vào.

create function cau_h(@nam int)
returns int
as
begin
	return (select COUNT(TrongTai) as sl
			from TranDau
			where YEAR(Ngay) = @nam )
end

select dbo.cau_h(2019) as sl

--Viết thủ tục vào tham số truyền vào là mã cầu thủ, thủ tục dùng để xóa cầu thủ này.
--(Gợi ý: nếu cầu thủ này đã từng tham gia ít nhất một trận đấu thì phải xóa dữ liệu ở
--bảng ThamGia trước rồi tiến hành xóa cầu thủ này)
alter proc cau_i
	@mact varchar(50)
as
	if(exists(select * from ThamGia where MaCT = @mact  ))
		begin
			delete from ThamGia
			where MaCT = @mact
			delete from CauThu
			where MaCT = @mact
		end
	else
		delete from CauThu
		where MaCT = @mact
cau_i S2

--Viết hàm với tham số truyền vào là macauthu, hàm dùng để lấy ra tổng bàn thắng của
-- cầu thủ này.

create function cau_j(@mact varchar(50))
returns int
as
begin
	return (select sum(SoTran)
			from ThamGia
			where MaCT = @mact)
end

select dbo.cau_j('S3')

--Viết một hàm trả về tổng bàn thắng mà mỗi cầu thủ ghi được trong tất cả các trận.
create function cau_k()
returns table
as
return (select MaCT, sum(SoTran) as st
		from ThamGia
		group by MaCT
		)
select * from dbo.cau_k()
--Viết thủ tục/hàm lấy danh sách các cầu thủ ghi nhiều bàn thắng nhất.

--THU TUC
create proc cau_l
as
	select top 1 CauThu.MaCT, TenCT, sum(ThamGia.SoTran) as sbt
	from CauThu join ThamGia on CauThu.MaCT = ThamGia.MaCT
	group by CauThu.MaCT,TenCT
	order by sbt desc
-- HAM
create function cau_l_ham()
returns table
as
return (select top 1 soBanThang.*
		from dbo.cau_k() as soBanThang 
					 order by soBanThang.st desc)
select * from dbo.cau_l_ham()

--m. Viết thủ tục/hàm với tham số truyền vào số A, thủ tục/hàm dùng để lấy ra danh sách các
--cầu thủ ghi số bàn thắng lớn hơn số A này.

-- HAM
alter function cau_m(@a int)
returns table
as
return (select TenCT ,soBanThang.MaCT,soBanThang.st 
		from dbo.cau_k() as soBanThang  join CauThu on soBanThang.MaCT = CauThu.MaCT
		where soBanThang.st > @a)

select * from dbo.cau_m(2)

--Viết thủ tục/hàm với tham số truyền vào là @nam. Thủ tục/hàm dùng để thống kê mỗi
-- tháng trong năm truyền vào có bao nhiêu trận đấu được diễn ra. Nếu tháng nào không
-- có trận đấu nào tổ chức thì ghi là 0.
--THU TUC
alter proc cau_n
	@nam int
as
begin
	declare @thang int = 1
	declare @soTran int
	declare @tblSoTranTrongNam table(thang int, soTran int)
	while @thang <= 12
		begin
			set @soTran = (select COUNT(MaTD)
						   from TranDau
						   where YEAR(Ngay) = @nam and MONTH(Ngay) = @thang)
			insert into @tblSoTranTrongNam values(@thang, @soTran)
			set @thang = @thang + 1
		end
		select * from @tblSoTranTrongNam
end
cau_n 2019

-- HAM
alter function cau_n_ham(@nam int)
returns @soTranDauTrongNam table (thang int, soTran int)
as
begin
	declare @thang int = 1
	declare @soTran int
	while @thang <= 12
		begin
			set @soTran = (select count(MaTD)
						  from TranDau
						  where YEAR(Ngay) = @nam and MONTH(Ngay) = @thang)
			insert into @soTranDauTrongNam 
			values (@thang, @soTran)
			set @thang = @thang + 1
		end
		return
end

select * from dbo.cau_n_ham(2019)

--Viết một thủ tục dùng để tạo ra một bảng mới có tên CauThu_BanThang, bảng này
-- chứa tổng số bàn thắng mà mỗi cầu thủ ghi được. Nếu cầu thủ nào chưa ghi bàn thắng
-- nào thì ghi số bàn thắng là 0.
alter proc cau_o
as
begin 
	create table CauThu_BanThang(
		MaCT varchar(50),
		TenCT varchar(50),
		soBanThang int
	)
	insert into CauThu_BanThang (MaCT,TenCT,soBanThang) 
	select CauThu.MaCT, TenCT, isnull(sum(SoTran),0) as banThang
	from CauThu left join ThamGia on CauThu.MaCT = ThamGia.MaCT
	group by CauThu.MaCT, TenCT
end
	
cau_o

--Viết một trigger, trigger này dùng để cập nhật tổng bàn thắng của cầu thủ ở bảng
--CauThu_BanThang mỗi khi có cập nhật hoặc thêm mới số bàn thắng của cầu thủ ở
--bảng ThamGia.

alter trigger cau_cuoi
on CauThu_BanThang
for insert,update
as
begin
	update ThamGia
	set ThamGia.SoTran = ThamGia.SoTran + deleted.soBanThang - inserted.soBanThang
	from ThamGia inner join inserted on ThamGia.MaCT = inserted.MaCT inner join deleted on ThamGia.MaCT = deleted.MaCT
end

update CauThu_BanThang
set soBanThang = 4
where MaCT = 'S11'
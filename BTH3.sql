-- cau a

create proc SelectOrderTop2
as
begin
	select top 2 Orderr.oID,oDate,pPrice
	from
		Orderr
		join OrderDetail on Orderr.oID = OrderDetail.oID
		join Product on OrderDetail.pID = Product.pID
	order by pPrice desc
end
SelectOrderTop2
-- cau b
create proc SelectOrderOderBy
as
begin
	select Orderr.oID,cID,oDate,oTotalPrice
	from
		Orderr
	order by oDate desc
end

SelectOrderOderBy

-- cau c
create proc NamePersonBuyProduct
as
begin
	select Customer.cID,cName,PName
	from
		Customer
		join Orderr on Customer.cID = Orderr.cID
		join OrderDetail on Orderr.oID = OrderDetail.oID
		join Product on OrderDetail.pID = Product.pID
end

NamePersonBuyProduct
--cau d
create proc SelectHoaDonThang3
@thang int
as
begin
	select Orderr.oID,oDate
	from 
		Orderr
		join OrderDetail on Orderr.oID  = OrderDetail.oID
	where MONTH(oDate) = @thang
end

SelectHoaDonThang3 3

-- cau e
alter proc DoanhThuMoiThang
@nam int
as
begin
	with Thang as(
	select 1 as thang
	union all select 2
	union all select 3
	union all select 5
	union all select 6
	union all select 7
	union all select 8
	union all select 9
	union all select 10
	union all select 11
	union all select 12
	)
	select Thang.thang,  SUM(odQTV * pPrice) as doanhthu
	from 
		Thang
		left join Orderr on MONTH(oDate) = Thang.thang and YEAR(oDate) = @nam
		left join OrderDetail on Orderr.oID = OrderDetail.oID
		left join Product on OrderDetail.pID = Product.pID
	group by Thang.thang
end

DoanhThuMoiThang 2006



-- cau f
alter proc CountBuyProductss
@nam int
as
begin
	select Customer.cID,COUNT(OrderDetail.oID) as N'solanmua'
	from
		Customer
		left join Orderr on Customer.cID = Orderr.cID
		left join OrderDetail on Orderr.oID = OrderDetail.oID
	where YEAR(oDate) = @nam or Orderr.cID is null
	group by  Customer.cID
end

CountBuyProductss 2006

-- cau g
alter proc MoneyBuyProduct
@nam int 
as
begin
	select Customer.cID,cName, sum(pPrice * odQTV) as 'money'
	from
	Customer
		left join Orderr on Customer.cID = Orderr.cID
		left join OrderDetail on Orderr.oID = OrderDetail.oID
		left join Product on OrderDetail.pID = Product.pID
	where YEAR(oDate) = @nam or Orderr.oID is NUll
	group by Customer.cID,cName
end

MoneyBuyProduct 2006

create proc total
@nam int 
as
begin
	select Orderr.oID,oDate, sum(pPrice * odQTV) as 'money'
	from
	Orderr
		left join OrderDetail on Orderr.oID = OrderDetail.oID
		left join Product on OrderDetail.pID = Product.pID
	where YEAR(oDate) = @nam or Orderr.oID is NUll
	group by Orderr.oID,oDate
end

total 2006


create proc totalHon30
@nam int 
as
begin
	select Orderr.oID,oDate, sum(pPrice * odQTV) as 'money'
	from
	Orderr
		left join OrderDetail on Orderr.oID = OrderDetail.oID
		left join Product on OrderDetail.pID = Product.pID
	where YEAR(oDate) = @nam 
	group by Orderr.oID,oDate
	having sum(pPrice * odQTV) > 30
end

totalHon30 2006



create proc countBuyProductHon3
as
begin
	select Customer.cID,cName, count(Customer.cID) as solanmua
	from 
	Customer
		left join Orderr on Customer.cID = Orderr.cID
		left join OrderDetail on Orderr.oID = OrderDetail.oID
	group by Customer.cID,cName
	having count(Customer.cID) > 3
end

countBuyProductHon3
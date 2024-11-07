-- cau a
create proc SelectOrderAll
as
	select * from Orderr
	order by oDate  desc 

SelectOrderAll

--cau b
create proc SelectKHiSBuyProduct
as
	select Customer.cName, Product.PName
	from Customer  join Orderr on Customer.cID = Orderr.cID
				   join OrderDetail on Orderr.oID = OrderDetail.oID
				   join Product on OrderDetail.pID = Product.pID
	order by Customer.cName
SelectKHiSBuyProduct

-- cau c -- cach left join

create proc SelectKH_iSBuyProductIsZero
as
	select Customer.cName
	from Customer  left join Orderr on Customer.cID = Orderr.cID
	where Orderr.oID is NULL
	order by Customer.cName
SelectKH_iSBuyProductIsZero

	-- cau c -- cach not in

create proc SelectKH_iSBuyProductIsZeroC2
as
	select Customer.cName
	from Customer 
	where Customer.cID not in (select cID from Orderr)

SelectKH_iSBuyProductIsZeroC2

-- cau d -- cach 1
create proc SelectBuyProductIsZero
as
	select Product.pID, Product.PName
	from Product left join OrderDetail on  Product.pID = OrderDetail.pID
	where OrderDetail.pID is null
SelectBuyProductIsZero
-- cau d -- cach 2

create proc SelectBuyProductIsZeroC2
as
	select Product.pID, Product.PName
	from Product
	where Product.pID not in (Select pID from OrderDetail)
SelectBuyProductIsZeroC2

-- cau e
alter proc SelectOrder
@nam int,@thang int
as
begin
	select Orderr.oID,oDate,  SUM(odQTV * pPrice) as N'So'
	from 
		Orderr
		 join OrderDetail on Orderr.oID = OrderDetail.oID
		 join Product on OrderDetail.pID = Product.pID
	where 
		YEAR(oDate) = @nam 
		and MONTH(oDate) = @thang
	group by Orderr.oID,oDate
end
SelectOrder 2006,3

-- cau f

alter proc SlectOrderMonth
@nam int
as
begin
	select MONTH(oDate) as thang , sum(pPrice * odQTV) as N'tong trong thang'
	from 
		Orderr
		join OrderDetail on Orderr.oID = OrderDetail.oID
		join Product on OrderDetail.pID = Product.pID 
	where YEAR(oDate) = @nam
	group by   MONTH(oDate)
end
SlectOrderMonth 2006

-- cau g
alter proc InsertProduct
@id int,
@name varchar(50),
@gia int,
@res varchar(255) output
as
begin
	if exists(select pID from Product where Product.pID = @id)
		set @res = N'Đã có sản phẩm này trong database'
	else
		begin
			insert into Product values(@id,@name,@gia)
			if @@ERROR <> 0
				set @res = 'loi'
			else 
				set @res = ''
		end
end

declare @res varchar(255)
execute updateProduct 7,'kia',49, @res output


-- cau h
alter proc updateProduct
@id int,
@name varchar(50),
@gia int,
@res varchar(255) output
as 
begin
	if not exists (select pID from Product where pID = @id)
		set @res = N'Khong ton tai san pham trong database'
	else
		begin
			update Product
			set 
				PName = @name,
				pPrice = @gia
			where pID = @id
			if @@ERROR <> 0
				set @res = N'loi update'
			else
				set @res = '' 
		end

end

declare @res varchar(50)
execute updateProduct 7, N'kia-k5',70, @res output

-- cau i
create proc deleteProduct
@id int,
@res varchar(255) output
as 
begin
	if not exists (select pID from Product where pID = @id)
		set @res = N'Khong ton tai san pham trong database'
	else
		begin
			delete from Product
			where pID = @id
			if @@ERROR <> 0
				set @res = N'loi delete'
			else
				set @res = '' 
		end

end

declare @res varchar(50)
execute deleteProduct 7, @res output

-- cau j
create proc CountBuyProduct
as
begin
	select Customer.cID,Customer.cName,OrderDetail.oID,COUNT(OrderDetail.oID) as N'so lan mua'
	from Customer  
		join Orderr on Customer.cID = Orderr.cID			   
		join OrderDetail on Orderr.oID = OrderDetail.oID
		join Product on OrderDetail.pID = Product.pID
	group by Customer.cID,Customer.cName,OrderDetail.oID
end

CountBuyProduct

-- cau k
create proc SelectFormat
as
begin
	select Orderr.oID, oDate,odQTV,PName,pPrice
	from Orderr
		join OrderDetail on Orderr.oID = OrderDetail.oID
		join Product on OrderDetail.pID = Product.pID
end

-- cau l
create proc SelectOrderTotal
as
begin
	select Orderr.oID,oDate,sum(pPrice * odQTV) as Total
	from Orderr
		join OrderDetail on  Orderr.oID = OrderDetail.oID
		join Product on OrderDetail.pID = Product.pID
	group by Orderr.oID,oDate
end
-- cau m
SelectOrderTotal

create proc SelectTop1_Price
as
begin
	select distinct top 1  PName, pPrice
	from Product
	order by pPrice desc
end
SelectTop1_Price

-- cau n
create proc SelectMoney
@money int
as
begin
	select Orderr.oID, sum(pPrice * odQTV) as total
	from Orderr
		join OrderDetail on Orderr.oID = OrderDetail.oID
		join Product on OrderDetail.pID = Product.pID
	group by  Orderr.oID
	having sum(pPrice * odQTV) = @money
	
end

SelectMoney 60

-- cau 0
create proc SelectOrderTotal_top1
as
begin
	select distinct top 1 Orderr.oID,oDate,sum(pPrice * odQTV) as Total
	from Orderr
		join OrderDetail on  Orderr.oID = OrderDetail.oID
		join Product on OrderDetail.pID = Product.pID
	group by Orderr.oID,oDate
end

SelectOrderTotal_top1

--cau p

create proc SelectCountBuyProduct
as
begin
	select Customer.cID,Customer.cName,COUNT(Orderr.cID) as N'so lan den mua'
	from Customer 
		left join Orderr on Customer.cID = Orderr.cID
	group by Customer.cID,Customer.cName
end

 SelectCountBuyProduct

 -- cau q
CREATE PROCEDURE ThongKeDoanhThuTheoThang
    @nam INT
AS
BEGIN
    -- Tạo danh sách 12 tháng (1 đến 12) bằng Common Table Expression (CTE)
    WITH Thang AS (
        SELECT 1 AS thang
        UNION ALL SELECT 2
        UNION ALL SELECT 3
        UNION ALL SELECT 4
        UNION ALL SELECT 5
        UNION ALL SELECT 6
        UNION ALL SELECT 7
        UNION ALL SELECT 8
        UNION ALL SELECT 9
        UNION ALL SELECT 10
        UNION ALL SELECT 11
        UNION ALL SELECT 12
    )
    
    SELECT 
        Thang.thang, 
        COALESCE(SUM(odQTV * pPrice), 0) AS TongDoanhThu
    FROM 
        Thang
        LEFT JOIN Orderr ON MONTH(oDate) = Thang.thang AND YEAR(oDate) = @nam
        LEFT JOIN OrderDetail ON Orderr.oID = OrderDetail.oID
        LEFT JOIN Product ON OrderDetail.pID = Product.pID
    GROUP BY 
        Thang.thang
    ORDER BY 
        Thang.thang;
END


 ThongKeDoanhThuTheoThang 2006
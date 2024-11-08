USE [BTH6]
GO
/****** Object:  Table [dbo].[Customer]    Script Date: 10/10/2024 9:53:34 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Customer](
	[cID] [int] NOT NULL,
	[cName] [nvarchar](50) NULL,
	[aAge] [tinyint] NULL,
 CONSTRAINT [PK_Customer] PRIMARY KEY CLUSTERED 
(
	[cID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[OrderDetail]    Script Date: 10/10/2024 9:53:34 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[OrderDetail](
	[oID] [int] NOT NULL,
	[pID] [int] NOT NULL,
	[odQTV] [int] NULL,
 CONSTRAINT [PK_OrderDetail] PRIMARY KEY CLUSTERED 
(
	[oID] ASC,
	[pID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Orderr]    Script Date: 10/10/2024 9:53:34 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Orderr](
	[oID] [int] NOT NULL,
	[cID] [int] NOT NULL,
	[oDate] [datetime] NULL,
	[oTotalPrice] [int] NULL,
 CONSTRAINT [PK_Order_1] PRIMARY KEY CLUSTERED 
(
	[oID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Product]    Script Date: 10/10/2024 9:53:34 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Product](
	[pID] [int] NOT NULL,
	[PName] [nvarchar](50) NULL,
	[pPrice] [int] NULL,
 CONSTRAINT [PK_Product] PRIMARY KEY CLUSTERED 
(
	[pID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[OrderDetail]  WITH CHECK ADD  CONSTRAINT [FK_OrderDetail_Order] FOREIGN KEY([oID])
REFERENCES [dbo].[Orderr] ([oID])
GO
ALTER TABLE [dbo].[OrderDetail] CHECK CONSTRAINT [FK_OrderDetail_Order]
GO
ALTER TABLE [dbo].[OrderDetail]  WITH CHECK ADD  CONSTRAINT [FK_OrderDetail_Product] FOREIGN KEY([pID])
REFERENCES [dbo].[Product] ([pID])
GO
ALTER TABLE [dbo].[OrderDetail] CHECK CONSTRAINT [FK_OrderDetail_Product]
GO
ALTER TABLE [dbo].[Orderr]  WITH CHECK ADD  CONSTRAINT [FK_Order_Customer] FOREIGN KEY([cID])
REFERENCES [dbo].[Customer] ([cID])
GO
ALTER TABLE [dbo].[Orderr] CHECK CONSTRAINT [FK_Order_Customer]
GO
/****** Object:  StoredProcedure [dbo].[CountBuyProduct]    Script Date: 10/10/2024 9:53:34 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create proc [dbo].[CountBuyProduct]
as
begin
	select Customer.cID,Customer.cName,OrderDetail.oID,COUNT(OrderDetail.oID) as N'so lan mua'
	from Customer  
		join Orderr on Customer.cID = Orderr.cID			   
		join OrderDetail on Orderr.oID = OrderDetail.oID
		join Product on OrderDetail.pID = Product.pID
	group by Customer.cID,Customer.cName,OrderDetail.oID
end
GO
/****** Object:  StoredProcedure [dbo].[deleteProduct]    Script Date: 10/10/2024 9:53:34 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create proc [dbo].[deleteProduct]
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
GO
/****** Object:  StoredProcedure [dbo].[SelectBuyProductIsZero]    Script Date: 10/10/2024 9:53:34 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create proc [dbo].[SelectBuyProductIsZero]
as
	select Product.pID, Product.PName
	from Product left join OrderDetail on  Product.pID = OrderDetail.pID
	where OrderDetail.pID is null
GO
/****** Object:  StoredProcedure [dbo].[SelectBuyProductIsZeroC2]    Script Date: 10/10/2024 9:53:34 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create proc [dbo].[SelectBuyProductIsZeroC2]
as
	select Product.pID, Product.PName
	from Product
	where Product.pID not in (Select pID from OrderDetail)
GO
/****** Object:  StoredProcedure [dbo].[SelectCauq]    Script Date: 10/10/2024 9:53:34 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
 CREATE proc [dbo].[SelectCauq]
 @nam int
 as
 begin
	select MONTH(oDate) as thang, COALESCE(SUM(odQTV * pPrice), 0) AS TongDoanhThu 
	from Orderr
		join OrderDetail on Orderr.oID = OrderDetail.oID
		join Product on OrderDetail.pID = Product.pID
	where YEAR(oDate) = @nam
	group by MONTH(oDate)
 end
GO
/****** Object:  StoredProcedure [dbo].[SelectCountBuyProduct]    Script Date: 10/10/2024 9:53:34 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create proc [dbo].[SelectCountBuyProduct]
as
begin
	select Customer.cID,Customer.cName,COUNT(Orderr.cID) as N'so lan den mua'
	from Customer 
		left join Orderr on Customer.cID = Orderr.cID
	group by Customer.cID,Customer.cName
end
GO
/****** Object:  StoredProcedure [dbo].[SelectKH_iSBuyProductIsZero]    Script Date: 10/10/2024 9:53:34 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

create proc [dbo].[SelectKH_iSBuyProductIsZero]
as
	select Customer.cName
	from Customer  left join Orderr on Customer.cID = Orderr.cID
	where Orderr.oID is NULL
	order by Customer.cName
GO
/****** Object:  StoredProcedure [dbo].[SelectKH_iSBuyProductIsZeroC2]    Script Date: 10/10/2024 9:53:34 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create proc [dbo].[SelectKH_iSBuyProductIsZeroC2]
as
	select Customer.cName
	from Customer 
	where Customer.cID not in (select cID from Orderr)
GO
/****** Object:  StoredProcedure [dbo].[SelectKHiSBuyProduct]    Script Date: 10/10/2024 9:53:34 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create proc [dbo].[SelectKHiSBuyProduct]
as
	select Customer.cName, Product.PName
	from Customer  join Orderr on Customer.cID = Orderr.cID
				   join OrderDetail on Orderr.oID = OrderDetail.oID
				   join Product on OrderDetail.pID = Product.pID
	order by Customer.cName
GO
/****** Object:  StoredProcedure [dbo].[SelectMoney]    Script Date: 10/10/2024 9:53:34 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- cau n
create proc [dbo].[SelectMoney]
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
GO
/****** Object:  StoredProcedure [dbo].[SelectOrder]    Script Date: 10/10/2024 9:53:34 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE proc [dbo].[SelectOrder]
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
GO
/****** Object:  StoredProcedure [dbo].[SelectOrderAll]    Script Date: 10/10/2024 9:53:34 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create proc [dbo].[SelectOrderAll]
as
	select * from Orderr
GO
/****** Object:  StoredProcedure [dbo].[SelectOrderTotal]    Script Date: 10/10/2024 9:53:34 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create proc [dbo].[SelectOrderTotal]
as
begin
	select Orderr.oID,oDate,sum(pPrice * odQTV) as Total
	from Orderr
		join OrderDetail on  Orderr.oID = OrderDetail.oID
		join Product on OrderDetail.pID = Product.pID
	group by Orderr.oID,oDate
end
GO
/****** Object:  StoredProcedure [dbo].[SelectOrderTotal_top1]    Script Date: 10/10/2024 9:53:34 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create proc [dbo].[SelectOrderTotal_top1]
as
begin
	select distinct top 1 Orderr.oID,oDate,sum(pPrice * odQTV) as Total
	from Orderr
		join OrderDetail on  Orderr.oID = OrderDetail.oID
		join Product on OrderDetail.pID = Product.pID
	group by Orderr.oID,oDate
end
GO
/****** Object:  StoredProcedure [dbo].[SelectTop1_Price]    Script Date: 10/10/2024 9:53:34 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create proc [dbo].[SelectTop1_Price]
as
begin
	select distinct top 1  PName, pPrice
	from Product
	order by pPrice desc
end
GO
/****** Object:  StoredProcedure [dbo].[SlectOrderMonth]    Script Date: 10/10/2024 9:53:34 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE proc [dbo].[SlectOrderMonth]
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
GO
/****** Object:  StoredProcedure [dbo].[ThongKeDoanhThuTheoThang]    Script Date: 10/10/2024 9:53:34 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[ThongKeDoanhThuTheoThang]
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
GO
/****** Object:  StoredProcedure [dbo].[updateProduct]    Script Date: 10/10/2024 9:53:34 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE proc [dbo].[updateProduct]
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
GO

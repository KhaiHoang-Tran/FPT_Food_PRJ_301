USE master;
GO

-- Kiểm tra nếu DB đã tồn tại thì xóa đi để tạo mới (tránh lỗi trùng)
IF EXISTS (SELECT name FROM sys.databases WHERE name = N'FPT_Food_PRJ')
BEGIN
    ALTER DATABASE FPT_Food_PRJ SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
    DROP DATABASE FPT_Food_PRJ;
END
GO

CREATE DATABASE FPT_Food_PRJ;
GO

USE FPT_Food_PRJ;
GO

-- 1. Bảng User (Người dùng: Admin, Khách, Bếp)
CREATE TABLE [User] (
    userID INT IDENTITY(1,1) PRIMARY KEY,
    username VARCHAR(50) NOT NULL UNIQUE,
    [password] VARCHAR(100) NOT NULL,
    role VARCHAR(20) NOT NULL CHECK (role IN ('user', 'manager', 'worker')),
    fullname NVARCHAR(100),
    phone VARCHAR(20),
    status VARCHAR(20) DEFAULT 'active' CHECK (status IN ('active', 'inactive'))
);

-- 2. Bảng DiningTable (Bàn ăn)
CREATE TABLE DiningTable (
    tableID INT IDENTITY(1,1) PRIMARY KEY,
    tableName NVARCHAR(50) NOT NULL,
    seatCount INT NOT NULL CHECK (seatCount > 0),
    status VARCHAR(20) DEFAULT 'empty' CHECK (status IN ('empty', 'busy', 'booked'))
);

-- 3. Bảng Category (Danh mục món ăn - Tạo trước bảng Food)
CREATE TABLE Category (
    categoryID INT IDENTITY(1,1) PRIMARY KEY,
    name NVARCHAR(50) NOT NULL UNIQUE,
    description NVARCHAR(200)
);

-- 4. Bảng Food (Món ăn - Đã sửa để liên kết Category và thêm Ảnh)
CREATE TABLE Food (
    foodID INT IDENTITY(1,1) PRIMARY KEY,
    name NVARCHAR(100) NOT NULL,
    price DECIMAL(10,2) NOT NULL CHECK (price >= 0),
    categoryID INT NULL, 
    status VARCHAR(20) DEFAULT 'available' CHECK (status IN ('available', 'unavailable')),
    
    FOREIGN KEY (categoryID) REFERENCES Category(categoryID)
);

-- 5. Bảng Voucher (Mã giảm giá)
CREATE TABLE Voucher (
    voucherID INT IDENTITY(1,1) PRIMARY KEY,
    code VARCHAR(20) NOT NULL UNIQUE,
    discountPercent INT CHECK (discountPercent > 0 AND discountPercent <= 100),
    startDate DATETIME DEFAULT GETDATE(),
    endDate DATETIME NOT NULL,
    minOrderValue DECIMAL(12,2) DEFAULT 0,
    status VARCHAR(20) DEFAULT 'active' CHECK (status IN ('active', 'expired'))
);

-- 6. Bảng Orders (Đơn hàng)
CREATE TABLE Orders (
    orderID INT IDENTITY(1,1) PRIMARY KEY,
    tableID INT NOT NULL,
    voucherID INT NULL, -- Liên kết Voucher
    status VARCHAR(20) DEFAULT 'pending' CHECK (status IN ('pending', 'cooking', 'done', 'paid')), -- Thêm 'paid' cho Manager
    totalPrice DECIMAL(12,2) DEFAULT 0,
    finalPrice DECIMAL(12,2) DEFAULT 0, -- Giá sau giảm
    createdTime DATETIME DEFAULT GETDATE(),

    CONSTRAINT FK_Orders_Table FOREIGN KEY (tableID) REFERENCES DiningTable(tableID),
    CONSTRAINT FK_Orders_Voucher FOREIGN KEY (voucherID) REFERENCES Voucher(voucherID)
);

-- 7. Bảng OrderItem (Chi tiết món trong đơn)
CREATE TABLE OrderItem (
    orderItemID INT IDENTITY(1,1) PRIMARY KEY,
    orderID INT NOT NULL,
    foodID INT NOT NULL,
    quantity INT NOT NULL CHECK (quantity > 0),
    price DECIMAL(10,2) NOT NULL CHECK (price >= 0),

    CONSTRAINT FK_OrderItem_Order FOREIGN KEY (orderID) REFERENCES Orders(orderID) ON DELETE CASCADE,
    CONSTRAINT FK_OrderItem_Food FOREIGN KEY (foodID) REFERENCES Food(foodID)
);

-- 8. Bảng Review (Đánh giá)
CREATE TABLE Review (
    reviewID INT IDENTITY(1,1) PRIMARY KEY,
    userID INT NOT NULL,
    foodID INT NOT NULL,
    rating INT CHECK (rating >= 1 AND rating <= 5),
    comment NVARCHAR(500),
    reviewDate DATETIME DEFAULT GETDATE(),
    
    FOREIGN KEY (userID) REFERENCES [User](userID),
    FOREIGN KEY (foodID) REFERENCES Food(foodID)
);

-- 9. Bảng Ingredient (Nguyên liệu kho)
CREATE TABLE Ingredient (
    ingredientID INT IDENTITY(1,1) PRIMARY KEY,
    name NVARCHAR(100) NOT NULL,
    unit NVARCHAR(20) NOT NULL,
    quantityInStock DECIMAL(10,2) DEFAULT 0,
    minThreshold DECIMAL(10,2) DEFAULT 5
);

-- 10. Bảng Recipe (Công thức nấu ăn)
CREATE TABLE Recipe (
    recipeID INT IDENTITY(1,1) PRIMARY KEY,
    foodID INT NOT NULL,
    ingredientID INT NOT NULL,
    amountNeeded DECIMAL(10,2) NOT NULL,
    
    FOREIGN KEY (foodID) REFERENCES Food(foodID),
    FOREIGN KEY (ingredientID) REFERENCES Ingredient(ingredientID)
);
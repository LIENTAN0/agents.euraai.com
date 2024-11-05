-- 创建数据库
CREATE DATABASE IF NOT EXISTS company_directory;

-- 使用数据库
USE company_directory;

-- 创建主表 companies
CREATE TABLE IF NOT EXISTS companies (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(255) NOT NULL COMMENT '公司名称',
    mobile VARCHAR(50) COMMENT '手机号码',
    website VARCHAR(255) COMMENT '网站',
    facebook VARCHAR(255) COMMENT 'Facebook链接',
    address TEXT COMMENT '地址',
    image_url VARCHAR(255) COMMENT '图片URL',
    source ENUM('修理工会', 'Map', 'Facebook', 'Google') COMMENT '来源',
    area VARCHAR(50) COMMENT '地区',
    latitude DECIMAL(10,8) COMMENT '纬度',
    longitude DECIMAL(11,8) COMMENT '经度',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- 创建视图
CREATE OR REPLACE VIEW companies_view AS
SELECT 
    id,
    name,
    mobile,
    website,
    facebook,
    address,
    image_url,
    source,
    area,
    latitude,
    longitude,
    created_at,
    updated_at
FROM companies;

-- 添加索引以提高查询性能
ALTER TABLE companies
ADD INDEX idx_source (source),
ADD INDEX idx_area (area),
ADD INDEX idx_created_at (created_at),
ADD INDEX idx_location (latitude, longitude);

-- 插入测试数据
INSERT INTO companies (
    name, 
    mobile, 
    website, 
    facebook, 
    address, 
    image_url, 
    source, 
    area, 
    latitude, 
    longitude
) VALUES 
(
    '修理工会测试店1',
    '012-345-6789',
    'www.test1.com',
    'fb.com/test1',
    '吉隆坡市中心路123号',
    '/images/xiuli1.jpg',
    '修理工会',
    '吉隆坡',
    3.1390,
    101.6869
),
(
    'Map测试店1',
    '012-345-6791',
    'www.test3.com',
    'fb.com/test3',
    '雪兰莪路125号',
    '/images/map1.jpg',
    'Map',
    '雪兰莪',
    3.0738,
    101.5183
);
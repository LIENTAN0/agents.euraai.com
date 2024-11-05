const express = require('express')
const mysql = require('mysql2')
const cors = require('cors')
const path = require('path')
const axios = require('axios')

const app = express()
app.use(cors({
  origin: '*',  // 允许所有来源访问
  methods: ['GET', 'POST'],
  allowedHeaders: ['Content-Type']
}));
app.use(express.json())
app.use('/images', (req, res, next) => {
  console.log('访问图片:', req.url);
  next();
}, express.static(path.join(__dirname, 'public', 'images')));

// 添加更多日志输出
console.log('开始连接数据库...');
const connection = mysql.createConnection({
  host: 'localhost',
  user: 'root',
  password: '12345',  // root 密码
  database: 'company_directory',
  port: 3306
});

// 添加连接监听
connection.connect(function(err) {
  if (err) {
    console.error('数据库连接失败:', err);
    return;
  }
  console.log('数据库连接成功!');
});

// 添加错误监听
connection.on('error', function(err) {
  console.error('数据库错误:', err);
});

// 测试查询
connection.query('SELECT 1', function(err, results) {
  if (err) {
    console.error('测试查询失败:', err);
    return;
  }
  console.log('测试查询成功!');
});

// 获取地区列表
app.get('/api/areas', (req, res) => {
  const query = `
    SELECT DISTINCT area 
    FROM companies_view 
    WHERE area IS NOT NULL 
      AND area != '' 
    ORDER BY area
  `;
  
  connection.query(query, (error, results) => {
    if (error) {
      console.error('查询地区失败:', error);
      return res.status(500).json({ error: error.message });
    }
    
    console.log('查询到的区:', results);
    
    const areas = results
      .map(result => result.area)
      .filter(area => area && area.trim());
    
    console.log('处理后的地区列表:', areas);
    res.json(areas);
  });
});

// 添加地址转坐标的函数
async function getCoordinatesFromAddress(address) {
  try {
    console.log('正在获取地址坐标:', address);
    const encodedAddress = encodeURIComponent(address);
    const response = await axios.get(
      `https://nominatim.openstreetmap.org/search?format=json&q=${encodedAddress}&countrycodes=my`
    );
    
    if (response.data && response.data.length > 0) {
      const coords = {
        latitude: parseFloat(response.data[0].lat),
        longitude: parseFloat(response.data[0].lon)
      };
      console.log('成功获取坐标:', coords);
      return coords;
    }
    console.log('未找到地址对应的坐标');
    return null;
  } catch (error) {
    console.error('地理编码错误:', error.message);
    return null;
  }
}

// 修改计算路程距离的函数
async function calculateRouteDistance(fromLat, fromLon, toLat, toLon) {
  try {
    // 确保所有参数都是有效的数字
    fromLat = parseFloat(fromLat);
    fromLon = parseFloat(fromLon);
    toLat = parseFloat(toLat);
    toLon = parseFloat(toLon);

    // 检查参数是否为有效数字
    if (isNaN(fromLat) || isNaN(fromLon) || isNaN(toLat) || isNaN(toLon)) {
      console.log('无效的坐标值:', { fromLat, fromLon, toLat, toLon });
      return null;
    }

    const R = 6371; // 地球半径（公里）
    const dLat = (toLat - fromLat) * Math.PI / 180;
    const dLon = (toLon - fromLon) * Math.PI / 180;
    const a = 
      Math.sin(dLat/2) * Math.sin(dLat/2) +
      Math.cos(fromLat * Math.PI / 180) * Math.cos(toLat * Math.PI / 180) * 
      Math.sin(dLon/2) * Math.sin(dLon/2);
    const c = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1-a));
    const distance = R * c;
    
    // 确保返回的是有效数字
    return isNaN(distance) ? null : distance;
  } catch (error) {
    console.error('计算距离时发生错误:', error);
    return null;
  }
}

// 修改获取公司列表的 API
app.get('/api/companies', async (req, res) => {
  const { source, area, userLat, userLon } = req.query;
  console.log('收到请求参数:', { source, area, userLat, userLon });
  
  let query = 'SELECT * FROM companies_view';
  const conditions = [];
  const params = [];
  
  if (source) {
    conditions.push('source = ?');
    params.push(source);
  }
  
  if (area) {
    conditions.push('area = ?');
    params.push(area);
  }
  
  if (conditions.length > 0) {
    query += ' WHERE ' + conditions.join(' AND ');
  }

  console.log('执行的SQL查询:', query, params);

  try {
    const results = await new Promise((resolve, reject) => {
      connection.query(query, params, (error, results) => {
        if (error) reject(error);
        else resolve(results);
      });
    });

    // 修改图片URL处理
    results.forEach(company => {
      if (!company.image_url) {
        company.image_url = 'https://picsum.photos/400/300'; // 默认图片
      } else if (company.image_url.startsWith('/images/')) {
        // 使用服务器IP
        company.image_url = `http://localhost:3000${company.image_url}`;
      }
    });

    console.log('查询到的公司数:', results.length);

    if (userLat && userLon) {
      for (let company of results) {
        if (company.latitude && company.longitude) {
          const distance = await calculateRouteDistance(
            userLat,
            userLon,
            company.latitude,
            company.longitude
          );
          company.distance = distance;
          console.log(`计算距离: ${company.name} - ${distance}km`);
        }
      }
    }

    res.json(results);
  } catch (error) {
    console.error('处理公司数据错误:', error);
    res.status(500).json({ error: error.message });
  }
});

const PORT = process.env.PORT || 3000
app.listen(PORT, '0.0.0.0', () => {
  console.log(`服务器运行在端口 ${PORT}`)
}) 
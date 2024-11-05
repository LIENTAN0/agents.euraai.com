<template>
  <div class="stores-container">
    <div class="header-space"></div>
    
    <div class="search-area">
      <div class="search-box">
        <svg class="search-icon" viewBox="0 0 24 24" width="18" height="18">
          <path fill="currentColor" d="M15.5 14h-.79l-.28-.27C15.41 12.59 16 11.11 16 9.5 16 5.91 13.09 3 9.5 3S3 5.91 3 9.5 5.91 16 9.5 16c1.61 0 3.09-.59 4.23-1.57l.27.28v.79l5 4.99L20.49 19l-4.99-5zm-6 0C7.01 14 5 11.99 5 9.5S7.01 5 9.5 5 14 7.01 14 9.5 11.99 14 9.5 14z"/>
        </svg>
        <input 
          v-model="searchQuery" 
          type="text" 
          placeholder="请输入店铺名字"
          @input="filterCompanies"
        >
      </div>
    </div>

    <div class="filter-options">
      <div class="filter-group">
        <div 
          class="distance-button" 
          :class="{ active: sortByDistance }"
          @click="toggleDistanceSort"
        >
          距离
          <svg 
            class="arrow-icon" 
            :class="{ 'arrow-up': sortByDistance }"
            viewBox="0 0 24 24" 
            width="16" 
            height="16"
          >
            <path 
              fill="currentColor" 
              d="M7 10l5 5 5-5z"
            />
          </svg>
        </div>
        
        <select v-model="selectedArea" class="filter-select">
          <option value="">选择地区</option>
          <option v-for="area in areas" 
                  :key="area" 
                  :value="area">
            {{ area }}
          </option>
        </select>
        
        <select v-model="selectedSource" class="filter-select">
          <option value="">选择来源</option>
          <option value="修理工会">修理工会</option>
          <option value="Map">Map</option>
          <option value="Facebook">Facebook</option>
          <option value="Google">Google</option>
        </select>
      </div>
    </div>

    <div class="companies-grid">
      <div v-for="company in filteredCompanies" 
           :key="company.id" 
           class="company-card"
           @click="handleCardClick(company)">
        <div class="company-image-container">
          <img 
            :src="company.image_url || 'https://picsum.photos/400/300'"
            :alt="company.name"
            class="company-image"
            @error="(e) => handleImageError(e, company)"
            data-retried="false"
            ref="imageRef"
          >
        </div>
        <div class="company-info">
          <h3>{{ company.name }}</h3>
          <div class="info-grid">
            <p>
              <svg class="icon" viewBox="0 0 24 24" width="16" height="16">
                <path fill="currentColor" d="M20 15.5c-1.2 0-2.4-.2-3.6-.6-.3-.1-.7 0-1 .2l-2.2 2.2c-2.8-1.4-5.1-3.8-6.6-6.6l2.2-2.2c.3-.3.4-.7.2-1-.3-1.1-.5-2.3-.5-3.5 0-.6-.4-1-1-1H4c-.6 0-1 .4-1 1 0 9.4 7.6 17 17 17 .6 0 1-.4 1-1v-3.5c0-.6-.4-1-1-1zM19 12h2c0-4.9-4-8.9-9-8.9v2c3.9 0 7 3.1 7 6.9z"/>
              </svg>
              {{ company.mobile }}
            </p>
            <p>
              <svg class="icon" viewBox="0 0 24 24" width="16" height="16">
                <path fill="currentColor" d="M12 2C8.13 2 5 5.13 5 9c0 5.25 7 13 7 13s7-7.75 7-13c0-3.87-3.13-7-7-7zm0 9.5c-1.38 0-2.5-1.12-2.5-2.5s1.12-2.5 2.5-2.5 2.5 1.12 2.5 2.5-1.12 2.5-2.5 2.5z"/>
              </svg>
              {{ company.address }}
            </p>
          </div>
        </div>
        <div class="distance-info" v-if="company.distance !== undefined">
          <span class="distance-value">{{ formatDistance(company.distance) }}</span>
        </div>
      </div>
    </div>

    <!-- 添加店铺详情弹窗 -->
    <div class="store-modal" v-if="selectedStore" @click="closeModal">
      <div class="modal-content" @click.stop>
        <div class="modal-header">
          <button class="back-button" @click="closeModal">
            <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
              <path d="M15 18l-6-6 6-6" />
            </svg>
          </button>
          <h2>{{ selectedStore.name }}</h2>
          <button class="close-button" @click="closeModal">×</button>
        </div>
        
        <div class="modal-body">
          <div class="store-image">
            <img 
              :src="selectedStore.image_url || 'https://picsum.photos/400/300'"
              :alt="selectedStore.name"
              @error="(e) => handleImageError(e, selectedStore)"
            >
          </div>
          
          <div class="store-details">
            <div class="detail-item">
              <svg class="icon" viewBox="0 0 24 24" width="20" height="20">
                <path fill="currentColor" d="M20 15.5c-1.2 0-2.4-.2-3.6-.6-.3-.1-.7 0-1 .2l-2.2 2.2c-2.8-1.4-5.1-3.8-6.6-6.6l2.2-2.2c.3-.3.4-.7.2-1-.3-1.1-.5-2.3-.5-3.5 0-.6-.4-1-1-1H4c-.6 0-1 .4-1 1 0 9.4 7.6 17 17 17 .6 0 1-.4 1-1v-3.5c0-.6-.4-1-1-1zM19 12h2c0-4.9-4-8.9-9-8.9v2c3.9 0 7 3.1 7 6.9z"/>
              </svg>
              <span class="label">电话：</span>
              <a :href="`tel:${selectedStore.mobile}`">{{ selectedStore.mobile }}</a>
            </div>
            
            <div class="detail-item">
              <svg class="icon" viewBox="0 0 24 24" width="20" height="20">
                <path fill="currentColor" d="M12 2C8.13 2 5 5.13 5 9c0 5.25 7 13 7 13s7-7.75 7-13c0-3.87-3.13-7-7-7zm0 9.5c-1.38 0-2.5-1.12-2.5-2.5s1.12-2.5 2.5-2.5 2.5 1.12 2.5 2.5-1.12 2.5-2.5 2.5z"/>
              </svg>
              <span class="label">地址：</span>
              <p>{{ selectedStore.address }}</p>
            </div>
            
            <div class="detail-item" v-if="selectedStore.distance">
              <svg class="icon" viewBox="0 0 24 24" width="20" height="20">
                <path fill="currentColor" d="M12 2L4.5 20.29l.71.71L12 18l6.79 3 .71-.71z"/>
              </svg>
              <span class="label">距离：</span>
              <span>{{ formatDistance(selectedStore.distance) }}</span>
            </div>
          </div>
        </div>
      </div>
    </div>
    </div>

</template>

<script>
import { ref, onMounted, watch, onUnmounted } from 'vue'
import axios from 'axios'

export default {
  name: 'StoresView',
  methods: {
    // 添加更新搜索查询的方法
    updateSearchQuery(query) {
      this.searchQuery = query;
      this.filterCompanies(); // 立即触发筛选
    },
    openModal(company) {
      this.selectedStore = company;
    },
    closeModal() {
      this.selectedStore = null;
    }
  },
  setup() {
    const userLocation = ref(null)
    const companies = ref([])
    const filteredCompanies = ref([])
    const selectedSource = ref('')
    const selectedArea = ref('')
    const areas = ref([])

    // 添加搜索键词
    const searchQuery = ref('')

    // 修改 fetchCompanies 函数，添加防抖
    const fetchCompanies = debounce(async () => {
      try {
        const params = {};
        if (userLocation.value) {
          params.userLat = userLocation.value.latitude;
          params.userLon = userLocation.value.longitude;
        }
        
        const response = await axios.get('/api/companies', { params });
        const data = Array.isArray(response.data) ? response.data : [];
        
        companies.value = data;
        filterCompanies();
      } catch (error) {
        console.error('获取公司数据失败:', error);
        companies.value = [];
        filteredCompanies.value = [];
      }
    }, 1000); // 1秒内的重复调用会被合并

    // 添加防抖函数
    function debounce(fn, delay) {
      let timer = null;
      return function (...args) {
        if (timer) clearTimeout(timer);
        timer = setTimeout(() => {
          fn.apply(this, args);
        }, delay);
      }
    }

    // 修改 filterCompanies 函数，添功能
    const filterCompanies = () => {
      let filtered = [...companies.value];
      
      // 搜索筛选
      if (searchQuery.value) {
        const query = searchQuery.value.toLowerCase().trim();
        filtered = filtered.filter(company => 
          company.name.toLowerCase().includes(query) ||
          company.address.toLowerCase().includes(query) ||
          (company.mobile && company.mobile.toLowerCase().includes(query))
        );
      }
      
      // 来源筛选
      if (selectedSource.value) {
        filtered = filtered.filter(company => company.source === selectedSource.value);
      }
      
      // 地区筛选
      if (selectedArea.value) {
        filtered = filtered.filter(company => company.area === selectedArea.value);
      }
      
      // 如果开启了距离排序
      if (sortByDistance.value) {
        filtered.sort((a, b) => {
          if (a.distance === null) return 1;
          if (b.distance === null) return -1;
          return a.distance - b.distance;
        });
      }
      
      filteredCompanies.value = filtered;
    }

    // 添加监听器来处理筛选条件的变化
    watch([selectedArea, selectedSource, searchQuery], () => {
      filterCompanies();
    }, { 
      deep: true,
      debounce: 300 // 添加防抖
    });

    // 使用 Haversine 公式计算直线距离
    const calculateDistance = (lat1, lon1, lat2, lon2) => {
      if (!lat1 || !lon1 || !lat2 || !lon2) {
        return null;
      }
      
      const R = 6371; // 地球半径（公里）
      const dLat = (lat2 - lat1) * Math.PI / 180;
      const dLon = (lon2 - lon1) * Math.PI / 180;
      const a = 
        Math.sin(dLat/2) * Math.sin(dLat/2) +
        Math.cos(lat1 * Math.PI / 180) * Math.cos(lat2 * Math.PI / 180) * 
        Math.sin(dLon/2) * Math.sin(dLon/2);
      const c = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1-a));
      return R * c;
    }

    const handleImageError = (e, company) => {
      const imageId = company.id + 
        (company.source === '修理工会' ? 100 : 
         company.source === 'Map' ? 200 :
         company.source === 'Facebook' ? 300 : 400);
         
      const defaultImageUrl = `https://picsum.photos/id/${imageId}/400/300`;
      
      if (e.target.src === defaultImageUrl || e.target.getAttribute('data-retried') === 'true') {
        return;
      }
      
      console.log('图片加载失败:', company.name, e.target.src);
      e.target.setAttribute('data-retried', 'true');
      e.target.src = defaultImageUrl;
    }

    // 修改获取用户位置的函数
    const getUserLocation = () => {
      if ("geolocation" in navigator) {
        navigator.geolocation.getCurrentPosition(
          position => {
            userLocation.value = {
              latitude: position.coords.latitude,
              longitude: position.coords.longitude
            }
            console.log('获取到用户位��:', userLocation.value);
            fetchCompanies(); // 获取到位置后重新获取数据
          },
          error => {
            console.error('获取位置失败:', error);
            // 使用吉隆坡市中心作为默认位置
            userLocation.value = {
              latitude: 3.1390,
              longitude: 101.6869
            }
            console.log('使用默认位置:', userLocation.value);
            fetchCompanies();
          },
          {
            enableHighAccuracy: true,
            timeout: 5000,
            maximumAge: 0
          }
        );
      }
    }

    // 格式化距离显示
    const formatDistance = (distance) => {
      if (distance === null || distance === undefined || isNaN(distance)) {
        return '未知距离';
      }
      
      if (distance < 1) {
        return `${Math.round(distance * 1000)}米`;
      } else if (distance < 10) {
        return `${distance.toFixed(1)}公里`;
      } else {
        return `${Math.round(distance)}公里`;
      }
    }

    // 修改 fetchAreas 函数
    const fetchAreas = async () => {
      try {
        const response = await axios.get('/api/areas');
        const data = Array.isArray(response.data) ? response.data : [];
        console.log('获取到的地区列表:', data);
        areas.value = data;
      } catch (error) {
        console.error('获取地区列表失败:', error);
        areas.value = [];
      }
    }

    onMounted(() => {
      getUserLocation();
      fetchAreas();
      
      // 移除 watchPosition，改用更合理的更新间隔
      const watchId = navigator.geolocation.watchPosition(
        position => {
          userLocation.value = {
            latitude: position.coords.latitude,
            longitude: position.coords.longitude
          }
          // 添加节流，避免频繁更新
          if (!lastUpdate || Date.now() - lastUpdate > 60000) { // 每分钟更新一次
            fetchCompanies();
            lastUpdate = Date.now();
          }
        },
        null,
        { 
          enableHighAccuracy: true,
          maximumAge: 30000, // 30秒的缓存
          timeout: 27000
        }
      );

      // 组件卸载时清理
      onUnmounted(() => {
        navigator.geolocation.clearWatch(watchId);
      });
    })

    // 移 selectedDistance，添加 sortByDistance
    const sortByDistance = ref(false)

    // 添加切换距离排序的方法
    const toggleDistanceSort = () => {
      sortByDistance.value = !sortByDistance.value;
      if (sortByDistance.value) {
        // 按距离排序
        filteredCompanies.value.sort((a, b) => {
          if (a.distance === null) return 1;
          if (b.distance === null) return -1;
          return a.distance - b.distance;
        });
      } else {
        // 恢复原始顺序
        filterCompanies();
      }
    }

    const selectedStore = ref(null)
    
    const openModal = (store) => {
      selectedStore.value = store
      document.body.style.overflow = 'hidden' // 防止背景滚动
    }
    
    const closeModal = () => {
      selectedStore.value = null
      document.body.style.overflow = '' // 恢复滚动
    }
    
    // 修改卡片点击事件
    const handleCardClick = (store) => {
      openModal(store)
    }

    return {
      companies,
      filteredCompanies,
      selectedSource,
      selectedArea,
      handleImageError,
      formatDistance,
      areas,
      userLocation,
      searchQuery,
      filterCompanies,
      sortByDistance,
      toggleDistanceSort,
      selectedStore,
      openModal,
      closeModal,
      handleCardClick
    }
  }
}
</script>

<style scoped>
.stores-container {
  padding-bottom: 10px;
  width: 100%;
  background-color: white;
}

.header-space {
  height: 50px;
  background-color: #1e90ff;
}

.companies-grid {
  display: grid;
  grid-template-columns: 1fr;
  gap: 1rem;
  padding: 16px;
  max-width: 1000px;
  margin: 0 auto;
}

/* 在大于768px的屏幕上显示两列 */
@media screen and (min-width: 768px) {
  .companies-grid {
    grid-template-columns: repeat(2, 1fr);
    gap: 16px;
  }
  
  /* 当只有一个或两个卡片时 */
  .companies-grid:has(.company-card:nth-last-child(-n+2):first-child) {
    max-width: 800px;
  }

  /* 当只有一张卡片时保持单列布局 */
  .companies-grid:has(.company-card:only-child) {
    grid-template-columns: 1fr;
    max-width: 800px;
  }
}

/* 移动端单列布局 */
@media screen and (max-width: 767px) {
  .companies-grid {
    max-width: 800px;
    padding: 12px;
    gap: 12px;
  }
}

@media screen and (max-width: 375px) {
  .companies-grid {
    padding: 8px;
    gap: 8px;
  }
}

.company-card {
  display: flex;
  flex-direction: row;
  border-radius: 12px;
  overflow: hidden;
  box-shadow: 0 4px 12px rgba(0,0,0,0.08);
  background-color: white;
  transition: transform 0.2s ease, box-shadow 0.2s ease;
  border: none;
  height: 160px;
  width: 100%;
  position: relative;
}

.company-card:hover {
  transform: translateY(-2px);
  box-shadow: 0 8px 16px rgba(0,0,0,0.12);
}

.company-image-container {
  width: 33.33%; /* 1/3 宽度 */
  height: 100%;
  overflow: hidden;
  position: relative;
  background-color: #f8f9fa;
  flex-shrink: 0; /* 防止图片容器被压缩 */
}

.company-image {
  width: 100%;
  height: 100%;
  object-fit: cover;
  transition: transform 0.3s ease;
}

.company-info {
  flex: 1;
  padding: 1.2rem;
  display: flex;
  flex-direction: column;
  justify-content: space-between;
  min-width: 0;
}

.info-grid {
  display: grid;
  grid-template-columns: 1fr;
  gap: 0.6rem; /* 增加间距 */
  margin-top: 1rem; /* 增加与标题的间距 */
}

.company-info h3 {
  margin: 0;
  color: #2c3e50;
  font-size: 1.2rem;
  font-weight: 600;
  line-height: 1.4;
}

.company-info p {
  margin: 0;
  color: #4a5568;
  font-size: 0.95rem;
  line-height: 1.4;
  display: flex;
  align-items: center; /* 改为居中对齐 */
  gap: 0.8rem;
}

.icon {
  flex-shrink: 0;
  color: #4299e1; /* 图标颜色 */
}

/* 地址文本可能很长，允许换行 */
.company-info p:last-child {
  align-items: flex-start; /* 地址图标靠上对齐 */
}

.company-info p:last-child .icon {
  margin-top: 3px; /* 微调地址图标位置 */
}

.company-info p strong {
  color: #2d3748;
  min-width: 65px;
  font-size: 0.9rem;
}

.filter-options {
  position: sticky;
  top: 50px;
  z-index: 100;
  background: white;
  box-shadow: 0 1px 3px rgba(0,0,0,0.1);
  padding: 6px 12px;
  margin-bottom: 4px;
}

.filter-group {
  display: flex;
  gap: 12px;
  width: 100%;
  max-width: 800px;
  margin: 0 auto;
  flex-direction: row; /* 确保始终横向排列 */
}

.filter-select, .distance-button {
  flex: 1;
  min-width: 0;
  padding: 4px 8px;
  height: 28px;
  font-size: 13px;
}

/* 移动端适配 */
@media screen and (max-width: 768px) {
  .filter-options {
    top: 45px;
    padding: 6px 12px;
  }

  .filter-group {
    flex-direction: row; /* 保持横向排列 */
    gap: 6px; /* 减小间距 */
  }

  .filter-select, .distance-button {
    padding: 4px 6px;
    font-size: 12px;
    height: 28px;
  }

  /* 调整下拉箭头的位置和大小 */
  .filter-select {
    background-position: right 4px center;
    background-size: 10px;
    padding-right: 16px; /* 为箭头留出空间 */
  }

  /* 调整距离按钮的样式 */
  .distance-button {
    padding: 4px 6px;
    font-size: 12px;
  }

  .arrow-icon {
    width: 12px;
    height: 12px;
  }
}

/* 更小屏幕的适配 */
@media screen and (max-width: 375px) {
  .filter-options {
    padding: 4px 6px;
  }

  .filter-group {
    gap: 4px;
  }

  .filter-select, .distance-button {
    padding: 2px 4px;
    font-size: 11px;
    height: 26px;
  }
}

/* 根据数据数量调整卡片样式 */
.companies-grid:has(.company-card:only-child) {
  max-width: 800px; /* 改为与多个卡片时相同的宽度 */
}

.companies-grid:has(.company-card:only-child) .company-card {
  /* 保持卡片原有的大小 */
  height: 160px; /* 与多个卡片时相同的高度 */
  width: 100%;
}

.companies-grid:has(.company-card:only-child) .company-image-container {
  width: 33.33%; /* 保持图片容器宽度为卡片的三分之一 */
}

/* 移动端适配 */
@media screen and (max-width: 768px) {
  .companies-grid:has(.company-card:only-child) {
    padding: 16px;
  }
  
  .companies-grid:has(.company-card:only-child) .company-card {
    height: auto;
    min-height: 100px;
  }
  
  .companies-grid:has(.company-card:only-child) .company-image-container {
    width: 100px;
    height: 100px;
  }
}

/* 添加距离显示的样式 */
.distance-info {
  display: flex;
  flex-direction: column;
  justify-content: center;
  align-items: center;
  padding: 0 0.8rem; /* 减小左右边距 */
  border-left: 1px solid #eee;
  min-width: 60px; /* 减小小宽度 */
  background-color: #f8f9fa;
}

.distance-value {
  font-size: 0.9rem; /* 减小字体大小 */
  font-weight: 500; /* 稍微减轻字重 */
  color: #2c3e50;
  text-align: center;
}

.distance-unit {
  font-size: 0.8rem;
  color: #666;
  margin-top: 2px;
}

.search-button {
  padding: 8px 16px;
  background-color: #4299e1;
  color: white;
  border: none;
  border-radius: 4px;
  cursor: pointer;
  font-size: 14px;
}

.search-button:hover {
  background-color: #3182ce;
}

/* 修改地址文本处理的样式 */
.company-info p:last-child {
  /* 使用更通用的多行文本截断方 */
  display: -webkit-box;
  display: -moz-box;
  display: box;
  -webkit-box-orient: vertical;
  -moz-box-orient: vertical;
  box-orient: vertical;
  -webkit-line-clamp: 2;
  line-clamp: 2;
  overflow: hidden;
  text-overflow: ellipsis;
  max-height: 2.6em; /* 作为后备方案，限制最大高度 */
  word-break: break-all;
}

/* 移动端适配 */
@media screen and (max-width: 768px) {
  .distance-info {
    padding: 0 0.5rem;
    min-width: 45px;
  }

  .distance-value {
    font-size: 0.8rem;
  }
}

/* 更小屏幕的适配 */
@media screen and (max-width: 375px) {
  .distance-info {
    padding: 0 0.4rem;
    min-width: 40px;
  }

  .distance-value {
    font-size: 0.75rem;
  }
}

/* 修改地址显示样式 */
.company-info p:last-child {
  /* 移除之前的文本截样式 */
  display: flex;
  align-items: flex-start;
  word-break: break-word;
  white-space: normal;
  line-height: 1.4;
  max-width: 100%;
}

/* 移动端适配 */
@media screen and (max-width: 768px) {
  .company-info {
    padding: 8px;
    flex: 1;
    min-width: 0;
    /* 增加下方内边距以显示完整地址 */
    padding-bottom: 12px;
  }

  .company-card {
    height: auto; /* 允许卡高度自适应 */
    min-height: 100px;
  }

  .company-info p:last-child {
    font-size: 0.75rem; /* 稍微减小字体大小 */
    line-height: 1.3;
    margin-top: 4px;
  }

  /* 调整图标位置 */
  .company-info p:last-child .icon {
    margin-top: 2px;
    width: 12px;
    height: 12px;
  }
}

/* 更小屏幕的适配 */
@media screen and (max-width: 375px) {
  .company-info p:last-child {
    font-size: 0.7rem;
  }
}

/* 添加搜索区域样式 */
.search-area {
  background-color: #1e90ff;
  padding: 8px 16px;
  margin-bottom: 0;
}

.search-box {
  background: white;
  border-radius: 8px;
  padding: 2px 12px;
  width: 100%;
  max-width: 800px;
  margin: 0 auto;
  display: flex;
  align-items: center;
  gap: 8px;
}

.search-icon {
  color: #666;
  flex-shrink: 0;
}

.search-box input {
  width: 100%;
  padding: 4px 0; /* 减小输入框内边距 */
  border: none;
  outline: none;
  font-size: 13px;
  background: transparent;
}

.search-box input::placeholder {
  color: #999;
}

/* 移动端适配 */
@media screen and (max-width: 768px) {
  .search-area {
    padding: 6px 16px;
    display: flex;
    justify-content: center; /* 居中显示 */
  }

  .search-box {
    width: 90%; /* 减小宽度 */
    max-width: 400px; /* 限制最大宽度 */
    padding: 2px 10px;
  }
}

/* 更小屏幕的适配 */
@media screen and (max-width: 375px) {
  .search-area {
    padding: 4px 12px;
  }

  .search-box {
    width: 85%; /* 更小屏幕进一步减小宽度 */
    max-width: 300px;
    padding: 2px 8px;
  }
}

/* 调整筛选器位置 */
.filter-options {
  position: sticky;
  top: 50px;
  z-index: 100;
  background: white;
  box-shadow: 0 1px 3px rgba(0,0,0,0.1);
  padding: 6px 12px;
  margin-bottom: 4px;
}

@media screen and (max-width: 768px) {
  .filter-options {
    top: 45px;
    padding: 6px 12px;
  }
}

@media screen and (max-width: 375px) {
  .filter-options {
    top: 45px;
    padding: 4px 10px;
  }
}

/* 修改距离按钮样 */
.distance-button {
  display: flex;
  align-items: center;
  gap: 4px;
  padding: 8px 12px;
  border: none;
  border-radius: 4px;
  font-size: 14px;
  color: #333;
  background-color: transparent;
  cursor: pointer;
  transition: all 0.2s ease;
  flex: 1;
  user-select: none;
}

.distance-button:hover {
  background-color: rgba(0, 0, 0, 0.05);
}

.distance-button.active {
  color: #1e90ff;
}

.arrow-icon {
  transition: transform 0.2s ease;
}

.arrow-icon.arrow-up {
  transform: rotate(180deg);
}

/* 移动端适配 */
@media screen and (max-width: 768px) {
  .distance-button {
    padding: 6px 8px;
    font-size: 0.85rem;
  }
  
  .arrow-icon {
    width: 14px;
    height: 14px;
  }
}

@media screen and (max-width: 375px) {
  .distance-button {
    padding: 4px 6px;
    font-size: 0.8rem;
  }
  
  .arrow-icon {
    width: 12px;
    height: 12px;
  }
}

/* 添加店铺详情弹窗样式 */
.store-modal {
  position: fixed;
  top: 0;
  left: 0;
  right: 0;
  bottom: 0;
  background-color: rgba(0, 0, 0, 0.75);
  display: flex;
  justify-content: center;
  align-items: center;
  z-index: 1100;
  padding: 24px;
  backdrop-filter: blur(10px);
}

.modal-content {
  background-color: #f8fafc;
  border-radius: 0; /* 移除圆角，变方形 */
  width: 100%;
  max-width: 480px;
  max-height: 85vh;
  overflow-y: scroll; /* 启用纵向滚动 */
  position: relative;
  box-shadow: 0 25px 50px -12px rgba(0, 0, 0, 0.25);
  /* 隐藏滚动条 - Webkit 浏览器 */
  &::-webkit-scrollbar {
    display: none;
  }
  /* 隐藏滚动条 - Firefox */
  scrollbar-width: none;
  /* 隐藏滚动条 - IE */
  -ms-overflow-style: none;
}

.modal-header {
  padding: 20px 24px;
  background: white;
  position: relative;
  text-align: center;
  border-bottom: 1px solid #eee;
}

.modal-header h2 {
  margin: 0;
  font-size: 1.2rem;
  color: #333;
  font-weight: 500;
  letter-spacing: 0;
}

.close-button {
  position: absolute;
  right: 20px;
  top: 50%;
  transform: translateY(-50%);
  width: 32px;
  height: 32px;
  border-radius: 0;
  border: none;
  background: transparent;
  color: #666;
  font-size: 20px;
  display: flex;
  align-items: center;
  justify-content: center;
  cursor: pointer;
  transition: background-color 0.2s ease;
}

.close-button:hover {
  background: rgba(0, 0, 0, 0.05);
  transform: translateY(-50%);
}

.modal-body {
  padding: 0;
  /* 移除 overflow-y，因为已经在 modal-content 中设置了滚动 */
}

.store-image {
  width: 100%;
  height: 280px;
  position: relative;
  overflow: hidden;
  background: #e2e8f0;
}

.store-image img {
  width: 100%;
  height: 100%;
  object-fit: cover;
  transition: transform 0.3s ease;
}

.store-image::after {
  content: '';
  position: absolute;
  bottom: 0;
  left: 0;
  right: 0;
  height: 100px;
  background: linear-gradient(to top, rgba(0,0,0,0.4), transparent);
}

.store-details {
  padding: 24px;
  display: flex;
  flex-direction: column;
  gap: 16px;
  background: white;
  border-radius: 24px;
  margin: -24px 16px 24px;
  position: relative;
  box-shadow: 0 4px 6px -1px rgba(0, 0, 0, 0.1);
}

.detail-item {
  display: flex;
  align-items: center;
  gap: 16px;
  padding: 16px;
  border-radius: 16px;
  background: #f8fafc;
  transition: all 0.2s ease;
}

.detail-item:hover {
  background: white;
  box-shadow: 0 4px 12px rgba(0, 0, 0, 0.05);
  transform: translateY(-2px);
}

.detail-item .icon {
  color: #2563eb;
  width: 24px;
  height: 24px;
  filter: drop-shadow(0 2px 4px rgba(37, 99, 235, 0.2));
}

.detail-item .label {
  font-weight: 600;
  color: #1e293b;
  min-width: 70px;
}

.detail-item a {
  color: #2563eb;
  font-weight: 500;
  text-decoration: none;
  padding: 6px 12px;
  border-radius: 8px;
  transition: all 0.2s ease;
}

.detail-item a:hover {
  background: rgba(37, 99, 235, 0.1);
}

@keyframes modalSlideIn {
  from {
    opacity: 1;
    transform: none;
  }
  to {
    opacity: 1;
    transform: none;
  }
}

/* 移端适配 */
@media screen and (max-width: 768px) {
  .store-modal {
    padding: 0; /* 在移动端移除内边距 */
  }

  .modal-content {
    height: 100vh; /* 在移动端占满全屏 */
    max-height: 100vh;
  }

  .modal-header {
    padding: 16px;
  }

  .modal-header h2 {
    font-size: 1.1rem;
  }
}

/* 修改筛选器样式 */
.filter-select {
  flex: 1;
  min-width: 0;
  padding: 6px 12px;
  height: 32px;
  font-size: 13px;
  border: 1px solid #e2e8f0;
  border-radius: 4px;
  background-color: #f1f5f9; /* 添加灰色背景 */
  color: #475569; /* 更深的文字颜色 */
  cursor: pointer;
  appearance: none;
  background-image: url("data:image/svg+xml;charset=UTF-8,%3csvg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 24 24' fill='none' stroke='%23475569' stroke-width='2' stroke-linecap='round' stroke-linejoin='round'%3e%3cpolyline points='6 9 12 15 18 9'%3e%3c/polyline%3e%3c/svg%3e");
  background-repeat: no-repeat;
  background-position: right 8px center;
  background-size: 16px;
  padding-right: 32px; /* 为箭头留出空间 */
  transition: all 0.2s ease;
}

.filter-select:hover {
  background-color: #e2e8f0; /* 悬停时稍微深一点 */
  border-color: #cbd5e1;
}

.filter-select:focus {
  outline: none;
  border-color: #93c5fd;
  background-color: #fff; /* 聚焦时改为白色背景 */
  box-shadow: 0 0 0 3px rgba(147, 197, 253, 0.15);
}

.filter-select option {
  background-color: white;
  color: #475569;
  padding: 8px;
}

/* 距离按钮样式也相应调整 */
.distance-button {
  display: flex;
  align-items: center;
  justify-content: center;
  gap: 4px;
  padding: 6px 12px;
  height: 32px;
  border: 1px solid #e2e8f0;
  border-radius: 4px;
  font-size: 13px;
  color: #475569;
  background-color: #f1f5f9;
  cursor: pointer;
  transition: all 0.2s ease;
  flex: 1;
  user-select: none;
}

.distance-button:hover {
  background-color: #e2e8f0;
  border-color: #cbd5e1;
}

.distance-button.active {
  background-color: #fff;
  color: #1e90ff;
  border-color: #93c5fd;
  box-shadow: 0 0 0 3px rgba(147, 197, 253, 0.15);
}

/* 移动端适配 */
@media screen and (max-width: 768px) {
  .filter-select {
    padding: 4px 24px 4px 8px; /* 调整内边距 */
    height: 28px;
    font-size: 12px;
    background-size: 14px;
    background-position: right 6px center;
  }

  .distance-button {
    padding: 4px 8px;
    height: 28px;
    font-size: 12px;
  }
}

/* 更小屏幕的适配 */
@media screen and (max-width: 375px) {
  .filter-select {
    padding: 3px 20px 3px 6px;
    height: 26px;
    font-size: 11px;
    background-size: 12px;
  }

  .distance-button {
    padding: 3px 6px;
    height: 26px;
    font-size: 11px;
  }
}

/* 修改卡片样式，确保移动端下的一致性 */
@media screen and (max-width: 768px) {
  .companies-grid {
    padding: 12px;
    gap: 12px;
  }

  .company-card {
    height: auto;
    min-height: 100px;
  }

  .company-image-container {
    width: 100px;
    height: 100px;
    flex-shrink: 0;
  }

  .company-info {
    padding: 8px;
    flex: 1;
    min-width: 0;
    padding-bottom: 12px;
  }

  /* 移除单个卡片的特殊样式 */
  .companies-grid:has(.company-card:only-child) {
    padding: 12px;
  }
  
  .companies-grid:has(.company-card:only-child) .company-card {
    height: auto;
    min-height: 100px;
  }
  
  .companies-grid:has(.company-card:only-child) .company-image-container {
    width: 100px;
    height: 100px;
  }

  .company-info h3 {
    font-size: 1rem;
    margin-bottom: 4px;
  }

  .info-grid {
    gap: 4px;
    margin-top: 4px;
  }

  .company-info p {
    font-size: 0.85rem;
    gap: 6px;
  }
}

/* 更小屏幕的适配 */
@media screen and (max-width: 375px) {
  .companies-grid {
    padding: 8px;
    gap: 8px;
  }

  .company-card {
    min-height: 90px;
  }

  .company-image-container {
    width: 90px;
    height: 90px;
  }

  .company-info {
    padding: 6px;
    padding-bottom: 10px;
  }

  .company-info h3 {
    font-size: 0.9rem;
  }

  .company-info p {
    font-size: 0.8rem;
  }
}

/* 修改模态框头部样式 */
.modal-header {
  padding: 20px 24px;
  background: white;
  position: relative;
  text-align: center;
  border-bottom: 1px solid #eee;
}

.modal-header h2 {
  margin: 0;
  font-size: 1.2rem;
  color: #333;
  font-weight: 500;
  letter-spacing: 0;
}

.close-button {
  position: absolute;
  right: 20px;
  top: 50%;
  transform: translateY(-50%);
  width: 32px;
  height: 32px;
  border: none;
  background: transparent;
  color: #666;
  font-size: 20px;
  display: flex;
  align-items: center;
  justify-content: center;
  cursor: pointer;
}

/* 添加返回按钮样式 */
.back-button {
  display: none; /* 默认隐藏 */
  position: absolute;
  left: 20px;
  top: 50%;
  transform: translateY(-50%);
  background: transparent;
  border: none;
  padding: 8px;
  cursor: pointer;
  color: #666;
}

.back-button svg {
  width: 20px;
  height: 20px;
}

/* 移动端适配 */
@media screen and (max-width: 768px) {
  .close-button {
    display: none; /* 隐藏关闭按钮 */
  }

  .back-button {
    display: flex; /* 显示返回按钮 */
    align-items: center;
  }

  .modal-header {
    padding: 16px;
  }

  .modal-header h2 {
    font-size: 1.1rem;
    margin: 0 40px; /* 为返回按钮留出空间 */
  }
}
</style> 
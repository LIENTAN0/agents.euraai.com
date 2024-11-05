<template>
  <div class="app">
    <header class="header">
      <nav>
        <template v-if="$route.path === '/stores'">
          <div class="stores-header">
            <div class="header-top">
              
                
              
              <div class="header-title">附近店铺</div>
            </div>
          </div>
        </template>
        <template v-else>
          <router-link to="/">首页</router-link> |
          <router-link to="/stores">附近店铺</router-link>
        </template>
      </nav>
    </header>
    <router-view></router-view>
  </div>
</template>

<script>
export default {
  methods: {
    goBack() {
      this.$router.push('/') // 返回首页
      // 或者使用 this.$router.back() 返回上一页
    }
  }
}
</script>

<style scoped>
/* 修改 header 样式 */
.header {
  background-color: #1e90ff;
  color: white;
  padding: 0;
  position: fixed;
  top: 0;
  left: 0;
  right: 0;
  z-index: 1000;
  height: 50px;
}

/* 其他样式保持不变... */

.stores-header {
  display: flex;
  height: 100%;
  padding: 0 30px;
  align-items: center;
}

.header-top {
  display: flex;
  align-items: center;
  width: 100%;
  height: 100%;
  position: relative;
}

.back-button {
  position: absolute;
  left: 0;
  font-size: 1.2rem;
  border: none;
  background: none;
  cursor: pointer;
  padding: 0.3rem;
  margin: 0;
  display: flex;
  align-items: center;
  color: white;
  user-select: none;
  z-index: 1;
}

.header-title {
  position: absolute;
  left: 50%;
  top: 15px;
  transform: translate(-50%, 0);
  font-size: 1.1rem;
  font-weight: 600;
  color: white;
  white-space: nowrap;
  letter-spacing: 0.5px;
  text-shadow: 0 1px 2px rgba(0, 0, 0, 0.1);
}

.back-button:hover {
  opacity: 0.8;
}

.back-button:active {
  opacity: 0.6;
}

/* 移动端适配 */
@media screen and (max-width: 768px) {
  .header {
    height: 45px;
  }

  .header-title {
    font-size: 1rem;
    top: 15px;
    letter-spacing: 0.3px;
  }
}

@media screen and (max-width: 375px) {
  .stores-header {
    padding: 0 20px;
  }

  .header-title {
    font-size: 0.95rem;
    top: 13px;
    letter-spacing: 0.2px;
  }
}
</style> 
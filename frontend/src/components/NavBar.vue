<template>
  <div class="nav-bar">
    <div class="nav-links">
      <router-link to="/" :class="{ active: $route.path === '/' }">Home</router-link>
      <router-link to="/about" :class="{ active: $route.path === '/about' }">About</router-link>
      <a href="/swagger" target="_blank" rel="noopener noreferrer">Swagger</a>
    </div>
    <div class="nav-title">Hello, Perld</div>
    <div class="nav-spacer"></div>
  </div>
</template>

<style scoped>
.nav-bar {
  display: flex;
  align-items: center;
  padding: 1rem 2rem;
  background-color: #2c3e50;
  border-bottom: 3px solid #3498db;
  box-shadow: 0 2px 4px rgba(0,0,0,0.1);
}

.nav-links {
  display: flex;
  gap: 1.5rem;
}

.nav-links a {
  text-decoration: none;
  color: #ecf0f1;
  font-weight: 500;
  padding: 0.5rem 1rem;
  border-radius: 4px;
  transition: all 0.2s;
  cursor: pointer;
}

.nav-links a:hover {
  background-color: #34495e;
  color: #3498db;
}

.nav-links a.active {
  background-color: #3498db;
  color: #fff;
}

.nav-title {
  position: absolute;
  left: 50%;
  transform: translateX(-50%);
  font-size: 1.5rem;
  font-weight: bold;
  color: #ecf0f1;
  letter-spacing: 0.5px;
}

.nav-spacer {
  flex: 1;
}
</style>

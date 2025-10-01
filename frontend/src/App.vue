<template>
  <div id="app">
    <NavBar />
    <ErrorBoundary>
      <router-view />
    </ErrorBoundary>
  </div>
</template>

<script setup>
import NavBar from './components/NavBar.vue'
import ErrorBoundary from './components/ErrorBoundary.vue'
</script>

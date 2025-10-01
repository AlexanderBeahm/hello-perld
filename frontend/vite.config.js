import { defineConfig } from 'vite'
import vue from '@vitejs/plugin-vue'
import path from 'path'

export default defineConfig({
  plugins: [vue()],

  // Set base to /dist/ so assets are referenced correctly when served by Mojolicious
  base: '/dist/',

  build: {
    outDir: '../lib/HelloPerld/Public/dist',
    emptyOutDir: true,
    // Disable source maps in production for security
    sourcemap: false,
    // Minification options
    minify: 'terser',
    terserOptions: {
      compress: {
        drop_console: true,
        drop_debugger: true
      }
    },
    rollupOptions: {
      output: {
        manualChunks: undefined,
      }
    }
  },

  server: {
    port: 5173,
    proxy: {
      '/api': {
        target: 'http://localhost:3000',
        changeOrigin: true
      },
      '/swagger': {
        target: 'http://localhost:3000',
        changeOrigin: true
      },
      '/swagger.json': {
        target: 'http://localhost:3000',
        changeOrigin: true
      }
    }
  },

  resolve: {
    alias: {
      '@': path.resolve(__dirname, './src')
    }
  }
})

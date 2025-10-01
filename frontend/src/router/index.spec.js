import { describe, it, expect } from 'vitest'
import { createMemoryHistory } from 'vue-router'
import router from './index.js'

describe('Router', () => {
  it('navigates to home page', async () => {
    await router.push('/')
    await router.isReady()
    expect(router.currentRoute.value.name).toBe('home')
  })

  it('navigates to about page', async () => {
    await router.push('/about')
    await router.isReady()
    expect(router.currentRoute.value.name).toBe('about')
  })

  it('has correct route paths', () => {
    const routes = router.getRoutes()
    const homePath = routes.find(r => r.name === 'home')
    const aboutPath = routes.find(r => r.name === 'about')

    expect(homePath.path).toBe('/')
    expect(aboutPath.path).toBe('/about')
  })
})

import { describe, it, expect } from 'vitest'
import { mount } from '@vue/test-utils'
import AboutPage from './AboutPage.vue'

describe('AboutPage', () => {
  it('renders the main heading', () => {
    const wrapper = mount(AboutPage)
    expect(wrapper.find('h1').text()).toBe('About HelloPerld')
  })

  it('renders all feature sections', () => {
    const wrapper = mount(AboutPage)
    expect(wrapper.text()).toContain('What is HelloPerld?')
    expect(wrapper.text()).toContain('Features')
    expect(wrapper.text()).toContain('Technology Stack')
  })

  it('displays feature list items', () => {
    const wrapper = mount(AboutPage)
    expect(wrapper.text()).toContain('RESTful API endpoints')
    expect(wrapper.text()).toContain('Vue 3 for frontend interactivity')
    expect(wrapper.text()).toContain('PostgreSQL for database')
  })

  it('applies correct styling classes', () => {
    const wrapper = mount(AboutPage)
    expect(wrapper.find('.about-page').exists()).toBe(true)
    expect(wrapper.find('.about-content').exists()).toBe(true)
  })
})

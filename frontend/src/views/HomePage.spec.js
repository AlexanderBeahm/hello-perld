import { describe, it, expect } from 'vitest'
import { mount } from '@vue/test-utils'
import HomePage from './HomePage.vue'

describe('HomePage', () => {
  it('renders the main heading', () => {
    const wrapper = mount(HomePage)
    expect(wrapper.find('h1').text()).toBe('Hello, Perld!')
  })

  it('applies correct styling classes', () => {
    const wrapper = mount(HomePage)
    expect(wrapper.find('.content').exists()).toBe(true)
  })
})

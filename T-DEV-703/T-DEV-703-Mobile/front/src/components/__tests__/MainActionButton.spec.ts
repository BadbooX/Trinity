import { describe, it, expect } from 'vitest'

import { mount } from '@vue/test-utils'
import MainActionButton from '@/components/MainActionButton.vue'

describe('MainActionButton', () => {
  it('renders a button', () => {
    const wrapper = mount(MainActionButton)
    expect(wrapper.find('button').exists()).toBe(true)
  })
})


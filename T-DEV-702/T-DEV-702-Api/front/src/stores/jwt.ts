import { ref } from 'vue'
import { defineStore } from 'pinia'
import type { User } from '@/types/user'
import { useRouter } from 'vue-router'

export const useJwtStore = defineStore(
  'jwt',
  () => {
    const jwt = ref(null) as { value: string | null }
    const setJwt = (newJwt: string) => {
      jwt.value = newJwt
    }
    const logout = () => {
      jwt.value = null
      useRouter().push('/')
    }

    const login = async (email: string, password: string) => {
      if (email === '' || password === '') {
        throw new Error('Email and password are required')
      }
      const res = await fetch('https://localhost:3000/api/login', {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
        },
        body: JSON.stringify({ email, password }),
      }).then((res) => {
        if (res.status === 401) {
          throw new Error('Invalid email or password')
        }
        if (res.status === 400) {
          throw new Error('Email and password are required')
        }
        if (res.status !== 201) {
          throw new Error('An error occurred')
        }
        return res.json()
      })
      setJwt(res.token)
      return true
    }

    const signup = async (user: User) => {
      if (user.email === '' || user.password === '') {
        throw new Error('Email and password are required')
      }
      await fetch('https://localhost:3000/api/register', {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
        },
        body: JSON.stringify({
          ...user,
        }),
      }).then((res) => {
        if (res.status === 401) {
          throw new Error('Invalid email or password')
        }
        if (res.status === 400) {
          throw new Error('All fields are required')
        }
        if (res.status !== 201) {
          throw new Error('An error occurred')
        }
        return res.json()
      })
      return true
    }

    return { jwt, setJwt, logout, login, signup }
  },
  {
    persist: true,
  },
)

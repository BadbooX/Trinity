import type { User } from "@/types/user";
import { defineStore } from "pinia";
import { ref } from "vue";
import { useJwtStore } from "./jwt";

export const useUserStore = defineStore('user', () => {
    const user = ref<User>({});

    const jwtStore = useJwtStore();

    const fetchMy = async () => {
        const res = await fetch('https://localhost:3000/api/users/my', {
            headers: {
                'Content-Type': 'application/json',
                'Authorization': `Bearer ${jwtStore.jwt}`
            }
        });
        if(res.status === 401) {
            throw new Error('Unauthorized');
        }
        if(res.status === 403) {
            throw new Error('Forbidden');
        }
        if(res.status === 400) {
            throw new Error('Missing parameters');
        }
        if(res.status === 404) {
            throw new Error('User not found');
        }
        if(res.status === 500) {
            throw new Error('Internal Server Error');
        }
        const data = await res.json();
        user.value = data;
    }

    const getMy = async () => {
        if(!user.value.id) {
            await fetchMy();
        }
        return user.value;
    }

    return { user, getMy };
    },
    {
        persist: true
    }

);
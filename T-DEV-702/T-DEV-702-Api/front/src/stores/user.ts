import type { User } from "@/types/user";
import { defineStore } from "pinia";

export const useUserStore = defineStore('user', () => {
    const user = {} as User;
    const setUser = (newUser: User) => {
        Object.assign(user, newUser);
    };
    return { user, setUser };
    });
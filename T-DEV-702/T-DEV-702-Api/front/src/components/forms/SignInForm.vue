<script lang="ts" setup>
import MainActionButton from '@/components/MainActionButton.vue';
import CustomInput from '@/components/CustomInput.vue';
import { ref, type Ref } from 'vue';
import { useJwtStore } from '@/stores/jwt';
import { IconAlternateEmailRounded, IconLockOpenOutlineRounded, IconLoginRounded } from '@iconify-prerendered/vue-material-symbols';
import { useRouter } from 'vue-router';

const user : Ref<{email: string, password: string}> = ref({
    email: '',
    password: ''
});
const router = useRouter();
const error: Ref<string> = ref('');
const success : Ref<boolean> = ref(false);

const jwtStore = useJwtStore();

const handleSubmit = async () => {
    if(!user.value.email || !user.value.password) {
        error.value = 'Please fill all fields';
        return;
    }
    try {
        await jwtStore.login(user.value.email, user.value.password);
    } catch (e) {
        const err = e as Error;
        error.value = err.message;
        return;
    }
    success.value = true;
    setTimeout(() => {
        router.push('/home');
    }, 2000);
}

</script>

<template>
    <form @keyup="error = ''">
        <CustomInput v-model="user.email" placeholder="Email" label="Email" type="email">
            <IconAlternateEmailRounded color="#de2618" font-size="24px" />
        </CustomInput>
        <CustomInput v-model="user.password" placeholder="Password" label="Password" type="password" >
            <IconLockOpenOutlineRounded color="#de2618" font-size="24px" />
        </CustomInput>
        <MainActionButton text="Sign in" :onClick="handleSubmit">
            <IconLoginRounded font-size="24px" />
        </MainActionButton>
        <p v-if="error !== ''" class="error"> {{ error }} </p>
        <p v-if="success" class="success">Successfully logged in!</p>
    </form>
</template>

<style scoped>

form {
    display: flex;
    flex-direction: column;
    gap: 1rem;
    width: 100%;
    align-items: center;
    justify-content: center;
}
</style>
<script lang="ts" setup>
import { ref } from 'vue';
import CustomInput from '../CustomInput.vue';
import { IconAd, IconAlternateEmailRounded, IconIdCardOutlineRounded, IconLockOpenOutlineRounded, IconSignatureRounded } from '@iconify-prerendered/vue-material-symbols';
import MainActionButton from '../MainActionButton.vue';
import InternalLink from '../InternalLink.vue';
import { useRouter } from 'vue-router';
import { useJwtStore } from '@/stores/jwt';
import { isValidPhoneNumber } from 'libphonenumber-js';

const router = useRouter();
const auth = useJwtStore();
const success = ref(false);
const error = ref("");
const user = ref({
    email: "",
    password: "",
    passwordConfirm: "",
    firstName: "",
    lastName: "",
    phone: ""
});

const validateEmail = (email : string) => {
  return String(email)
    .toLowerCase()
    .match(
      /^(([^<>()[\]\\.,;:\s@"]+(\.[^<>()[\]\\.,;:\s@"]+)*)|.(".+"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$/
    );
};

const handleSubmit = async () => {
    if (!user.value.email || !user.value.password || !user.value.firstName || !user.value.lastName) {
        error.value = "Please fill all fields";
        return;
    }
    if (user.value.password !== user.value.passwordConfirm) {
        error.value = "Passwords do not match";
        return;
    }
    if(!validateEmail(user.value.email)) {
        error.value = "Invalid email";
        return;
    }
    if(!isValidPhoneNumber(user.value.phone)) {
        error.value = "Invalid phone number";
        return;
    }
    try {
        await auth.signup(user.value);
    } catch (e) {
        const err = e as Error
        error.value = err.message;
        return;
    }
    success.value = true;
    setTimeout(() => {
        router.push('/login');
    }, 2000);
}; 

</script>

<template>
    <form>
        <CustomInput type="text" v-model="user.firstName" label="Firstname" placeholder="John">
            <IconIdCardOutlineRounded color="#de2618" font-size="24px" />
        </CustomInput>
        <CustomInput type="text" v-model="user.lastName" label="Lastname" placeholder="Doe">
            <IconSignatureRounded color="#de2618" font-size="24px" />
        </CustomInput>
        <CustomInput type="email" v-model="user.email" label="Email" placeholder="john.doe@example.com">
            <IconAlternateEmailRounded color="#de2618" font-size="24px" />
        </CustomInput>
        <CustomInput type="tel" v-model="user.phone" label="Phone" placeholder="0601020304">
            <IconAlternateEmailRounded color="#de2618" font-size="24px" />
        </CustomInput>
        <CustomInput type="password" v-model="user.password" label="Password" placeholder="*******">
            <IconLockOpenOutlineRounded color="#de2618" font-size="24px" />
        </CustomInput>
        <CustomInput type="password" v-model="user.passwordConfirm" label="Confirm password" placeholder="********">
            <IconLockOpenOutlineRounded color="#de2618" font-size="24px" />
        </CustomInput>
        <MainActionButton text="Sign up" :onClick="handleSubmit" :disabled="false">
            <IconAd font-size="24px" />
        </MainActionButton>
        <p class="error" v-if="error !== ''">{{ error }}</p>
        <p class="success" v-if="success">Account created ! Login <InternalLink text="here" to="/login" /> </p>
    </form>
</template>

<style scoped>
form {
    gap: 1rem;
}

</style>
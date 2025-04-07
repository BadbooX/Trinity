<template>
  <footer>
    <RouterLink to="/about" class="footer-link"> About </RouterLink>
    <RouterLink to="/contact" class="footer-link"> Contact </RouterLink>
    <RouterLink to="/terms" class="footer-link"> Terms of Service </RouterLink>
    <RouterLink to="/privacy" class="footer-link"> Privacy Policy </RouterLink>
    <a href="https://localhost:3000/api/docs" class="footer-link"> API </a>
    <RouterLink to="/manager" class="footer-link"> Manager </RouterLink>
    <RouterLink to="/dev" class="footer-link"> Developer </RouterLink>
  </footer>
</template>

<style scoped>
    footer {
        display: flex;
        justify-content: center;
        align-items: center;
        gap: 1rem;
        margin-top: 2rem;
        width: 100%;
        background-color: white;
        margin-left: 0px;
        margin-bottom: -15px;
    }

    .footer-link {
        color: #000;
        text-decoration: underline 4px solid #DE1628;
        font-size: 1em;
        font-family: 'Railway', sans-serif;
        padding: 1em;
    }

    .footer-link:hover {
        animation: highlight ease-in-out 1s;
    }

    @keyframes highlight {
        0% {
            background-color: transparent;
        }
        100% {
            background-color: #DE1628;
        }
    }
</style>


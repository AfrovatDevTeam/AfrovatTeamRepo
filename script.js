// ===== USERS SETUP =====
let users = [
    { username: "kiasha", password: "1234", attempts: 0 },
    { username: "alex", password: "abcd", attempts: 0 }
];

// Save users to localStorage if not present
if (!localStorage.getItem("users")) {
    localStorage.setItem("users", JSON.stringify(users));
}

// ===== LOGIN PAGE LOGIC =====
const loginForm = document.getElementById("loginForm");
if (loginForm) {
    const errorMsg = document.getElementById("error");
    const usernameInput = document.getElementById("username");
    const passwordInput = document.getElementById("password");
    const rememberMe = document.getElementById("rememberMe");

    // Auto-login if Remember Me active
    const storedUser = localStorage.getItem("loggedInUser");
    if (storedUser) {
        window.location.href = "dashboard.html";
    }

    loginForm.addEventListener("submit", function (e) {
        e.preventDefault();

        const users = JSON.parse(localStorage.getItem("users") || "[]");
        const username = usernameInput.value.trim();
        const password = passwordInput.value;

        const user = users.find(u => u.username === username);

        if (!user) {
            errorMsg.textContent = "User not found!";
            return;
        }

        if (user.attempts >= 3) {
            errorMsg.textContent = "Account locked after 3 wrong attempts!";
            return;
        }

        if (user.password === password) {
            user.attempts = 0; // reset attempts
            localStorage.setItem("users", JSON.stringify(users));

            if (rememberMe.checked) {
                localStorage.setItem("loggedInUser", username);
            } else {
                sessionStorage.setItem("loggedInUser", username);
            }

            window.location.href = "dashboard.html";
        } else {
            user.attempts++;
            localStorage.setItem("users", JSON.stringify(users));
            errorMsg.textContent = ' Wrong password! Attempts: {user.attempts}/3';
        }
    });
}

// ===== DASHBOARD PAGE LOGIC =====
const welcomeText = document.getElementById("welcome");
const logoutBtn = document.getElementById("logoutBtn");

if (welcomeText) {
    const loggedInUser = sessionStorage.getItem("loggedInUser") || localStorage.getItem("loggedInUser");
    if (!loggedInUser) {
        window.location.href = "index.html"; // redirect if not logged in
    } else {
        welcomeText.textContent = 'Welcome, {loggedInUser}!';
    }
}

if (logoutBtn) {
    logoutBtn.addEventListener("click", function () {
        sessionStorage.removeItem("loggedInUser");
        localStorage.removeItem("loggedInUser");
        window.location.href = "index.html";
    });
}

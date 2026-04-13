// USERS (your login database)
const users = [
  { username: "admin", password: "1234" },
  { username: "kabelo", password: "pass123" },
  { username: "student", password: "school" }
];

let attempts = 0;

// ON LOAD: if user already logged in, show dashboard
window.onload = function () {
  const savedUser = localStorage.getItem("loggedUser");
  if (savedUser) {
    showDashboard(savedUser);
  }
};

// THIS is the function your HTML calls.
// It MUST be named exactly: login()
function login() {
  const usernameEl = document.getElementById("username");
  const passwordEl = document.getElementById("password");

  const rememberEl = document.getElementById("rememberMe");
  const errorMsgEl = document.getElementById("errorMsg");

  const username = usernameEl ? usernameEl.value.trim() : "";
  const password = passwordEl ? passwordEl.value : "";
  const remember = rememberEl ? rememberEl.checked : false;

  if (!errorMsgEl) return;

  // lock after 3 failed attempts
  if (attempts >= 3) {
    errorMsgEl.innerText = "Account locked. Too many failed attempts.";
    return;
  }

  // check user
  const validUser = users.find(
    (u) => u.username === username && u.password === password
  );

  if (validUser) {
    attempts = 0;

    if (remember) {
      localStorage.setItem("loggedUser", username);
    } else {
      localStorage.removeItem("loggedUser");
    }

    showDashboard(username);
    errorMsgEl.innerText = "";
  } else {
    attempts++;
    errorMsgEl.innerText =
      "Wrong username or password. Attempt " + attempts + "/3";
  }
}

// show dashboard
function showDashboard(username) {
  const loginBox = document.getElementById("loginBox");
  const dashboard = document.getElementById("dashboard");
  const welcomeUser = document.getElementById("welcomeUser");

  if (loginBox) loginBox.style.display = "none";
  if (dashboard) dashboard.style.display = "block";
  if (welcomeUser) welcomeUser.innerText = "Welcome, " + username + " 👋";
}

// logout
function logout() {
  localStorage.removeItem("loggedUser");

  const loginBox = document.getElementById("loginBox");
  const dashboard = document.getElementById("dashboard");

  if (dashboard) dashboard.style.display = "none";
  if (loginBox) loginBox.style.display = "block";
}
// WAIT UNTIL PAGE LOADS

window.onload = function(){

checkLogin();

initializeBookingSystem();

};


// LOGIN SYSTEM

const users = [
{username:"admin", password:"1234"},
{username:"kabelo", password:"pass123"},
{username:"karabo", password:"246"}
];


function login(){

const username = document.getElementById("username").value;
const password = document.getElementById("password").value;

const validUser = users.find(user =>
user.username === username && user.password === password
);

if(validUser){

localStorage.setItem("loggedUser", username);

showDashboard(username);

}
else{

document.getElementById("errorMsg").innerText = "Invalid username or password";

}

}


function showDashboard(username){

document.getElementById("loginBox").style.display = "none";
document.getElementById("dashboard").style.display = "block";

const welcome = document.getElementById("welcomeUser");

if(welcome){
welcome.innerText = "Welcome " + username;
}

}


function logout(){

localStorage.removeItem("loggedUser");

location.reload();

}


function checkLogin(){

const savedUser = localStorage.getItem("loggedUser");

if(savedUser){

showDashboard(savedUser);

}

}



// BOOKING SYSTEM

let reservations = JSON.parse(localStorage.getItem("reservations")) || [];

let form;
let reservationList;
let totalPriceText;


function initializeBookingSystem(){

form = document.getElementById("bookingForm");
reservationList = document.getElementById("reservationList");
totalPriceText = document.getElementById("totalPrice");

if(!form) return;

displayReservations();

form.addEventListener("submit", function(e){

e.preventDefault();

const name = document.getElementById("name").value;
const email = document.getElementById("email").value;
const roomType = document.getElementById("roomType").value;
const checkin = document.getElementById("checkin").value;
const checkout = document.getElementById("checkout").value;

const nights = calculateNights(checkin, checkout);

if(nights <= 0){
alert("Checkout date must be after check-in date.");
return;
}

const totalPrice = calculateTotalPrice(roomType, nights);

// CHECK ROOM AVAILABILITY

if(!isRoomAvailable(roomType, checkin, checkout)){
alert("This room is already booked for the selected dates.");
return;
}

const reservation = {
name,
email,
roomType,
checkin,
checkout,
nights,
totalPrice
};

reservations.push(reservation);

localStorage.setItem("reservations", JSON.stringify(reservations));

displayReservations();

form.reset();

if(totalPriceText){
totalPriceText.innerText = "";
}

});

}



// CALCULATE NIGHTS

function calculateNights(checkin, checkout){

const checkinDate = new Date(checkin);
const checkoutDate = new Date(checkout);

const difference = checkoutDate - checkinDate;

const nights = difference / (1000 * 60 * 60 * 24);

return nights;

}



// CALCULATE TOTAL PRICE

function calculateTotalPrice(roomType, nights){

let pricePerNight = 0;

if(roomType === "Single"){
pricePerNight = 500;
}
else if(roomType === "Double"){
pricePerNight = 800;
}
else if(roomType === "Suite"){
pricePerNight = 1500;
}

const total = pricePerNight * nights;

if(totalPriceText){
totalPriceText.innerText =
"Total Price: R" + total + " (" + nights + " nights)";
}

return total;

}



// PREVENT DOUBLE BOOKING

function isRoomAvailable(roomType, checkin, checkout){

for(let i = 0; i < reservations.length; i++){

const existing = reservations[i];

if(existing.roomType === roomType){

if(
(checkin >= existing.checkin && checkin < existing.checkout) ||
(checkout > existing.checkin && checkout <= existing.checkout) ||
(checkin <= existing.checkin && checkout >= existing.checkout)
){
return false;
}

}

}

return true;

}



// DISPLAY RESERVATIONS

function displayReservations(){

if(!reservationList) return;

reservationList.innerHTML = "";

reservations.forEach((res, index)=>{

const li = document.createElement("li");

li.innerHTML =
`${res.name} | ${res.roomType} | ${res.checkin} To ${res.checkout} | ${res.nights} nights | R${res.totalPrice}
<button onclick="deleteReservation(${index})">Cancel</button>`;

reservationList.appendChild(li);

});

}



// DELETE RESERVATION

function deleteReservation(index){

reservations.splice(index, 1);

localStorage.setItem("reservations", JSON.stringify(reservations));

displayReservations();

}
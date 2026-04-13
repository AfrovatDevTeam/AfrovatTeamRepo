let man = document.getElementById("man");
let scoreText = document.getElementById("score");
let timeText = document.getElementById("time");
let gameArea = document.getElementById("gameArea");
let startBtn = document.getElementById("startBtn");

let score = 0;
let timeLeft = 10;
let speed = 2000;

let movement;
let timer;
let gameRunning = false;

let emojis = ["👨","🧑","👷","🕵️","🧑‍🚀","🧑‍💻"];



// MOVE CHARACTER

function moveMan(){

let maxX = gameArea.clientWidth - 40;
let maxY = gameArea.clientHeight - 40;

let randomX = Math.random() * maxX;
let randomY = Math.random() * maxY;

man.style.left = randomX + "px";
man.style.top = randomY + "px";

let randomEmoji = emojis[Math.floor(Math.random()*emojis.length)];

man.textContent = randomEmoji;

}



// START GAME

startBtn.addEventListener("click", function(){

score = 0;
timeLeft = 10;
speed = 2000;

scoreText.textContent = score;
timeText.textContent = timeLeft;

gameRunning = true;

moveMan();

movement = setInterval(moveMan, speed);

timer = setInterval(function(){

timeLeft--;

timeText.textContent = timeLeft;

if(timeLeft <= 0){

clearInterval(timer);
clearInterval(movement);

gameRunning = false;

alert("Game Over! Your score: " + score);

}

},1000);

});



// CLICK CHARACTER

man.addEventListener("click", function(){

if(!gameRunning) return;

score++;
scoreText.textContent = score;

speed -= 100;

if(speed < 400){
speed = 400;
}

clearInterval(movement);
movement = setInterval(moveMan, speed);

moveMan();

});



// MISS PENALTY

gameArea.addEventListener("click", function(e){

if(e.target !== man && gameRunning){

score--;

if(score < 0){
score = 0;
}

scoreText.textContent = score;

}

});
let counter1 = Number(localStorage.getItem("c1")) || 0;
let counter2 = Number(localStorage.getItem("c2")) || 0;
let counter3 = Number(localStorage.getItem("c3")) || 0;

const maxLimit = 20;

function updateDisplay(){

document.getElementById("counter1").innerText = counter1;
document.getElementById("counter2").innerText = counter2;
document.getElementById("counter3").innerText = counter3;

let total = counter1 + counter2 + counter3;
document.getElementById("total").innerText = total;

checkColor();
highestCounter();

localStorage.setItem("c1", counter1);
localStorage.setItem("c2", counter2);
localStorage.setItem("c3", counter3);

flash("counter1");
flash("counter2");
flash("counter3");
}

function flash(id){
let el = document.getElementById(id);
el.classList.add("flash");

setTimeout(()=>{
el.classList.remove("flash");
},300);
}

function checkColor(){

document.getElementById("counter1").classList.toggle("red", counter1>10);
document.getElementById("counter2").classList.toggle("red", counter2>10);
document.getElementById("counter3").classList.toggle("red", counter3>10);

}

function highestCounter(){

let highest = Math.max(counter1,counter2,counter3);
let name = "None";

if(highest === counter1 && highest>0) name="Counter 1";
if(highest === counter2 && highest>0) name="Counter 2";
if(highest === counter3 && highest>0) name="Counter 3";

document.getElementById("highest").innerText = name;

}

function increase1(){
if(counter1 < maxLimit){
counter1++;
updateDisplay();
}
}

function increase2(){
if(counter2 < maxLimit){
counter2++;
updateDisplay();
}
}

function increase3(){
if(counter3 < maxLimit){
counter3++;
updateDisplay();
}
}

function decrease1(){
if(counter1 > 0){
counter1--;
updateDisplay();
}
}

function decrease2(){
if(counter2 > 0){
counter2--;
updateDisplay();
}
}

function decrease3(){
if(counter3 > 0){
counter3--;
updateDisplay();
}
}

function resetCounters(){
counter1=0;
counter2=0;
counter3=0;

updateDisplay();
}

updateDisplay();
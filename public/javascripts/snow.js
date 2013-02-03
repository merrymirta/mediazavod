var snowsrc="/images/snow.gif" //путь к изображению снежинки
var no = 50; //кол-во снежинок
var hidesnowtime = 0; //время показа (в секундах), при 0 - бесконечно
var snowdistance = "pageheight";
var ie4up = (document.all) ? 1 : 0; //определение типа браузера
var ns6up = (document.getElementById&&!document.all) ? 1 : 0; //определение типа браузера

function iecompattest(){
return (document.compatMode && document.compatMode!="BackCompat")? document.documentElement : document.body
}

var dx, xp, yp;
var am, stx, sty;
var i, doc_width = 800, doc_height = 600; // размеры

if (ns6up) {
doc_width = self.innerWidth;
doc_height = self.innerHeight;
} else if (ie4up) {
doc_width = iecompattest().clientWidth;
doc_height = iecompattest().clientHeight;
}

dx = new Array();
xp = new Array();
yp = new Array();
am = new Array();
stx = new Array();
sty = new Array();
for (i = 0; i < no; ++i) { //запускаем цикл вывода снежинок
dx[i] = 0;
xp[i] = Math.random()*(doc_width-50); // координата снежинки по X
yp[i] = Math.random()*doc_height; //координата снежинки по Y
am[i] = Math.random()*20; // амплитуда
stx[i] = 0.02 + Math.random()/10; // расстояние между снежинками по Х
sty[i] = 0.7 + Math.random(); // расстояние между снежинками по Y
if (ie4up||ns6up) {
document.write("<div id=\"sneg"+ i +"\" style=\"POSITION: absolute; Z-INDEX: "+ i +"; VISIBILITY: visible; TOP: 15px; LEFT: 15px;\"><img src='"+snowsrc+"' border=\"0\"><\/div>");
}
}

function snowIE_NS6() { // Снежинки для InternetExplorer и NetScape6
doc_width = ns6up?window.innerWidth-10 : iecompattest().clientWidth-10;
doc_height=(window.innerHeight && snowdistance=="windowheight")? window.innerHeight : (ie4up && snowdistance=="windowheight")? iecompattest().clientHeight : (ie4up && !window.opera && snowdistance=="pageheight")? iecompattest().scrollHeight : iecompattest().offsetHeight;
for (i = 0; i < no; ++i) { //смотри описание выше, то же самое
yp[i] += sty[i];
if (yp[i] > doc_height-50) {
xp[i] = Math.random()*(doc_width-am[i]-30);
yp[i] = 0;
stx[i] = 0.02 + Math.random()/10;
sty[i] = 0.7 + Math.random();
}
dx[i] += stx[i];
document.getElementById("sneg"+i).style.top=yp[i]+"px";
document.getElementById("sneg"+i).style.left=xp[i] + am[i]*Math.sin(dx[i])+"px";
}
snowtimer=setTimeout("snowIE_NS6()", 10);
}

function hidesnow(){ // исчезновение снежинок с истечением времени
if (window.snowtimer) clearTimeout(snowtimer)
for (i=0; i<no; i++) document.getElementById("sneg"+i).style.visibility="hidden"
}

if (ie4up||ns6up){
snowIE_NS6();
if (hidesnowtime>0)
setTimeout("hidesnow()", hidesnowtime*1000)
}
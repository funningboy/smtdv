
var last_element = null;
var new_win = null;
function goto(line, file) {
  new_win = null;
  new_win = null;
  new_win = window.open(file,'mywindow','scrollbars=1');
  addOnLoadEvent(line);  
  setTimeout("init(" + line + ")", 10);
}

function addOnLoadEvent(line) {
  if (new_win.attachEvent) {
    new_win.onload = init(line);
  } else {
    new_win.onload = function() {init(line); };
  }
}


function init(line) {
  var lines; 
  if (new_win.document.documentElement.innerText) {
    lines = new_win.document.documentElement.innerText.split("\n");
  } else if (new_win.document.documentElement.textContent) {
    lines = new_win.document.documentElement.textContent.split("\n");
  } else {
    alert("Source Browesr is available with FireFox and InternetExplorer browsers only" + new_win.document.documentElement);
  }
  new_win.document.write('<head><link rel="stylesheet" type="text/css" href="edoc.css" /></head>');
  for (i in lines) {
    var j = parseInt(i) + 1;
    if (i % 2 == 0) {
      new_win.document.write("<div class=even id=line_");
    } else {
      new_win.document.write("<div class=odd id=line_");
    }
    new_win.document.write(i + "><div class=line_number>" + j + ".</div><span class=code>"  + lines[i] + "</span></div>");
  }
  
  new_win.document.close();
  setTimeout("goto2(" + line + ")", 5);

  //new_win.goto2(line);
}
function goto2(line) {
  var l = line;
  var d = new_win.document;
  if (last_element) {
    last_element.style.backgroundColor="";
  }
  var e=d.getElementById("line_" + (l - 1));
  if (e) {
    var offset_correction = e.offsetTop < 50 ? 0 : 50;
    e.style.backgroundColor="#D8F4FD";
    last_element = e;
    new_win.scroll(0, e.offsetTop - offset_correction);
    new_win.focus();
  }
}

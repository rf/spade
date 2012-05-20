// This is a test harness for your module
// You should do something interesting in this harness 
// to test out the module and to provide instructions 
// to users on how to use it by example.

var spade = require('org.russfrank.spade');

var win = Ti.UI.createWindow({
	backgroundColor:'white',
  layout: 'vertical'
});

var btn = Ti.UI.createButton({
  title: 'this is a test'
});

win.add(btn);

btn.addEventListener('click', function () { alert('clicked'); });

setTimeout(function () {
  //var searched = spade.find('this.*test');

  //if (searched) spade.tap(searched);
  
  spade.tapText('this.*test');
}, 3000);

win.open();

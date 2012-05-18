// This is a test harness for your module
// You should do something interesting in this harness 
// to test out the module and to provide instructions 
// to users on how to use it by example.

var spade = require('org.russfrank.spade');

var win = Ti.UI.createWindow({
	backgroundColor:'white',
  layout: 'vertical'
});

var view1 = Ti.UI.createView({ backgroundColor:'#123', width: 250 });
var view2 = Ti.UI.createView({ backgroundColor:'#246', width: 250 });
var view3 = Ti.UI.createView({ backgroundColor:'#48b', width: 250 });

var scrollableView = Ti.UI.createScrollableView({
  views: [view1,view2,view3],
  showPagingControl: true,
  width: 320,
  height: 300
});

var field = Ti.UI.createTextField({width: 200, height: 40, borderStyle: Ti.UI.INPUT_BORDERSTYLE_ROUNDED});

win.add(field);
win.add(scrollableView);

scrollableView.addEventListener('scroll', function () {
  Ti.API.debug('view1 says ' + spade.visible(view1));
  Ti.API.debug('view2 says ' + spade.visible(view2));
  Ti.API.debug('view3 says ' + spade.visible(view3));
});

setTimeout(function () {
  spade.drag(scrollableView, {x: 319, y: 200}, {x: 1, y: 200});
  spade.tapAt(view1, {x: 10, y: 40});

}, 3000);

view1.addEventListener('click', function (e) { Ti.API.debug(e); });

win.open();
  
setTimeout(function() {
  spade.tap(field);
  spade.type(field, "HELLO WORLD, hello world!");
}, 2000);

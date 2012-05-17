// This is a test harness for your module
// You should do something interesting in this harness 
// to test out the module and to provide instructions 
// to users on how to use it by example.

var testi = require('org.russfrank.spade');

var win = Ti.UI.createWindow({
	backgroundColor:'white'
});

setTimeout(function () {
}, 2000);

var view1 = Ti.UI.createView({ backgroundColor:'#123', width: 250 });
var view2 = Ti.UI.createView({ backgroundColor:'#246', width: 250 });
var view3 = Ti.UI.createView({ backgroundColor:'#48b', width: 250 });

var scrollableView = Ti.UI.createScrollableView({
  views: [view1,view2,view3],
  showPagingControl: true,
  width: 320,
  height: 430
});

win.add(scrollableView);

scrollableView.addEventListener('scroll', function () {
  setTimeout(function () {
    Ti.API.debug('view1 says ' + testi.visible(view1));
    Ti.API.debug('view2 says ' + testi.visible(view2));
    Ti.API.debug('view3 says ' + testi.visible(view3));
  }, 1000);
});

win.add(scrollableView);

setTimeout(function () {
  Ti.API.debug('dragging');
  testi.drag(scrollableView, {x: 319, y: 100}, {x: 1, y: 100});
}, 4000);

view1.addEventListener('click', function (e) { Ti.API.debug(JSON.stringify(e,null,4)); });

setTimeout(function () {
  Ti.API.debug('tapping');
  testi.tap(view1);
}, 2000);

win.open();


// This is a test harness for your module
// You should do something interesting in this harness 
// to test out the module and to provide instructions 
// to users on how to use it by example.

var testi = require('org.russfrank.spade');

var win = Ti.UI.createWindow({
	backgroundColor:'white'
});

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
  Ti.API.debug('view1 says ' + testi.visible(view1));
  Ti.API.debug('view2 says ' + testi.visible(view2));
  Ti.API.debug('view3 says ' + testi.visible(view3));
});

win.add(scrollableView);

setTimeout(function () {
  testi.drag(scrollableView, {x: 319, y: 200}, {x: 1, y: 200});
  testi.tapAt(view1, {x: 10, y: 40});
}, 3000);

view1.addEventListener('click', function (e) { Ti.API.debug(e); });

win.open();

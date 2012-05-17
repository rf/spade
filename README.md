# spade

Spade is a native iOS and Android module for Titanium which allows you to
inject events into your application.  It is one component of a system for
automated user interface testing for Titanium apps.  This is accomplished with
Square's [Keep It Functional](https://github.com/square/KIF) on iPhone and
Jayway's [Robotium](https://github.com/jayway/robotium) on Android.

Currently, this is not a test framework; it is just a collection of functions
which can be used to inject events.  The module provides the following functions
on both iOS and Android:

### tap (view)

Tap a view in the center.

### tapAt (view, point)

Tap a view at a set of coordinates in relation to the view.

### drag (view, from, to)

Drag along a view, again, local coords.

### visible (view)

Check if a view is visible on screen.

## Usage

You can extract the module zip files into your project directory and edit
the `tiapp.xml` file. Then, do something like this

```javascript
var spade = require('org.russfrank.spade');

var win = Ti.UI.createWindow();
var button = Ti.UI.createButton({title: 'hello'});
win.add(button);
win.open();

button.addEventListener('click', function () { Ti.API.debug('world') });

setTimeout(function () {
  spade.tap(button);
}, 5000);
```

After five seconds, you should see 'world' in your console.

## Future

The functionality of this module is currently very limited; for use in a real
testing situation, it still needs the ability to press buttons on Android,
enter text, search for views, etc.

This isn't all that difficult though.  The frameworks I chose are pretty
featureful.

After that, it needs some kindof harness. Appcelerator's Drillbit might do for
this.

## Note about the Apple App Store

Your app will be rejected if you submit it with this module linked in.  This
should be obvious.

## License

MIT.

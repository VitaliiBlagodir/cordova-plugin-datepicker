# DatePicker iOS Plugin for using PhoneGap / Cordova 3.0 (iOS 7 beta ready)

This is a re-write of the iOS DatePicker plugin hosted on [https://github.com/phonegap/phonegap-plugins/tree/master/iOS/DatePicker](https://github.com/phonegap/phonegap-plugins/tree/master/iOS/DatePicker) to run with PhoneGap/Cordova 3.0. 

It includes [more options](#options) and it is ready for iPhone and iPad.

## Screen shots

### iPhone (iOS 6)
![screen shot iPhone](https://raw.github.com/sectore/phonegap3-ios-datepicker-plugin/master/assets/screenshot.jpg)

### iPhone (iOS 7)
![screen shot iPhone](https://raw.github.com/sectore/phonegap3-ios-datepicker-plugin/master/assets/screenshot_ios7.jpg)

### iPad (iOS 6)
![screen shot iPad](https://raw.github.com/sectore/phonegap3-ios-datepicker-plugin/master/assets/screenshot_ipad.jpg)

### iPad (iOS 7)
![screen shot iPad](https://raw.github.com/sectore/phonegap3-ios-datepicker-plugin/master/assets/screenshot_ipad_ios7.jpg)

## Installation

1) Make sure that you have [Node](http://nodejs.org/) and [Cordova CLI](https://github.com/apache/cordova-cli) or [PhoneGap's CLI](https://github.com/mwbrooks/phonegap-cli) or [Cordova Plugman](https://github.com/apache/cordova-plugman/) installed on your machine.

Also you will need Xcode v.4.2 or newer to support the feature called ["Automatic Reference Counting"](http://developer.apple.com/library/ios/#documentation/DeveloperTools/Conceptual/WhatsNewXcode/Articles/xcode_4_2.html)

2) Add a plugin to your project using [Cordova CLI](https://github.com/apache/cordova-cli):

```bash
cordova plugin add https://github.com/sectore/phonegap3-ios-datepicker-plugin
```

Or using [PhoneGap CLI](https://github.com/mwbrooks/phonegap-cli):

```bash
phonegap local plugin add https://github.com/sectore/phonegap3-ios-datepicker-plugin
```

Or using [plugman CLI](https://github.com/apache/cordova-plugman#command-line-usage):

```bash
plugman --platform ios --project ./platforms/ios --plugin https://github.com/sectore/phonegap3-ios-datepicker-plugin
```


3a) Register plugin within `config.xml` of your app

```xml
<feature name="DatePicker">
    <param name="ios-package" value="DatePicker"/>
</feature>
```

3b) If you are using [PhoneGap build service](https://build.phonegap.com/) add to `config.xml`

```xml
<gap:plugin name="de.websector.datepicker" />
```

4) The `clobber` definition of the plugin is called `datePicker`. So you can reference to the plugin from anywhere in your code.

Example:

```js
// defining options
var options = {
  date: new Date(),
  mode: 'date'
};
// calling show() function with options and a result handler
datePicker.show(options, function(date){
  console.log("date result " + date);  
});
```

Check section ["Options"](#options) below to see all options.

## Options

### mode
The mode of the date picker.

Typ: `String` 

Values: `"date"` / `"time"` / `"datetime"`

Default: `'datetime'`

### date
Selected date.

Typ: `String`

Default: `new Date()`

### allowOldDates
Shows or hide dates earlier then selected date.

Typ: `Boolean`

Values: `true` / `false`

Default: `true`

### allowFutureDates
Shows or hide dates after selected date.

Typ: `Boolean`

Values: `true` / `false`

Default: `true`

### minDate (new)
Minimum date.

Typ: `Date` or empty `String`

Default: `''` (empty String)

### maxDate (new)
Maximum date.

Typ: `Date` or empty `String`

Default: `''` (empty String)

### doneButtonLabel (new)
Label of done button.

Typ: `String`

Default: `'Done'`

### doneButtonColor (new)
Hex color of done button.

Typ: `String`

Default: `'#0000FF'`

### cancelButtonLabel (new)
Label of cancel button.

Typ: `String`

Default: `'Cancel'`

### cancelButtonColor (new)
Hex color of cancel button.

Typ: `String`

Default: `'#000000'`

### x (new)
X position of date picker (iPad only). The position is absolute to the root view of the application.

Typ: `String`

Default: `'0'`

### y (new)
Y position of date picker (iPad only). The position is absolute to the root view of the application.

Typ: `String`

Default: `'0'`

## Requirements
- PhoneGap 3.0 or newer /Cordova 3.0 or newer
- iOS 5 or newer

## Author of migration to PhoneGap 3.0
Jens Krause // [WEBSECTOR.DE](http://www.websector.de)




[![Bitdeli Badge](https://d2weczhvl823v0.cloudfront.net/sectore/phonegap3-ios-datepicker-plugin/trend.png)](https://bitdeli.com/free "Bitdeli Badge")


# DatePicker Plugin for Cordova/PhoneGap 4.0 (iOS and Android and Windows), Ionic 1.3 (tested on Android and iOS)

Original version https://github.com/VitaliiBlagodir/cordova-plugin-datepicker

New in this fork (Android Only):

- Android code refactored

- Option datetime added (default if mode is unknown), opening a new time dialog after setting the date

- Options okText and cancelText to define the labels for POSITIVE and NEGATIVE buttons

- Option todayText to set the label of a button that selects current date (date and datetime)

- Option nowText to set the label of a button that selects current time (time and datetime)

- Option is24Hour added

## Installation

1) Make sure that you have [Node](http://nodejs.org/) and [Cordova CLI](https://github.com/apache/cordova-cli) or [PhoneGap's CLI](https://github.com/mwbrooks/phonegap-cli) installed on your machine.

2) Add a plugin to your project using Cordova CLI:

```bash
cordova plugin add https://github.com/andrelsmoraes/cordova-plugin-datepicker.git
```
Or using PhoneGap CLI:

```bash
phonegap local plugin add https://github.com/andrelsmoraes/cordova-plugin-datepicker.git
```
Or using Ionic CLI:

```bash
ionic plugin add https://github.com/andrelsmoraes/cordova-plugin-datepicker.git
```

## Usage

```js
var options = {
  date: new Date(),
  mode: 'date'
};

datePicker.show(options, function(date){
  alert("date result " + date);  
});
```

## Options

### mode - iOS, Android, Windows
The mode of the date picker.

Type: String

Values: `date` | `time` | `datetime`

Default: `date`

### date - iOS, Android, Windows
Selected date.

Type: String

Default: `new Date()`

### minDate - iOS, Android, Windows
Minimum date.

Type: Date | empty String

Default: `(empty String)`

minDate is a Date object for iOS and an integer for Android, so you need to account for that when using the plugin.

### maxDate - iOS, Android, Windows
Maximum date.

Type: Date | empty String

Default: `(empty String)` 

### okText - Android
Label of BUTTON_POSITIVE (done button). If empty, uses android.R.string.ok.

Type: String | empty String

Default: `(empty String)` 

### cancelText - Android
Label of BUTTON_NEGATIVE (cancel button). If empty, uses android.R.string.cancel.

Type: String | empty String

Default: `(empty String)` 

### todayText - Android
Label of today button. If empty, doesn't show the option to select current date.

Type: String | empty String

Default: `(empty String)` 

### nowText - Android
Label of now button. If empty, doesn't show the option to select current time.

Type: String | empty String

Default: `(empty String)` 

### is24Hour - Android
Shows time dialog in 24 hours format.

Type: Boolean

Values: `true` | `false`

Default: `false`

### allowOldDates - iOS
Shows or hide dates earlier then selected date.

Type: Boolean

Values: `true` | `false`

Default: `true`

### allowFutureDates - iOS
Shows or hide dates after selected date.

Type: Boolean

Values: `true` | `false`

Default: `true`

### doneButtonLabel - iOS
Label of done button.

Typ: String

Default: `Done`

### doneButtonColor - iOS
Hex color of done button.

Typ: String

Default: `#0000FF`

### cancelButtonLabel - iOS
Label of cancel button.

Type: String

Default: `Cancel`

### cancelButtonColor - iOS
Hex color of cancel button.

Type: String

Default: `#000000`

### x - iOS (iPad only)
X position of date picker. The position is absolute to the root view of the application.

Type: String

Default: `0`

### y - iOS (iPad only)
Y position of date picker. The position is absolute to the root view of the application.

Type: String

Default: `0`

### minuteInterval - iOS
Interval between options in the minute section of the date picker.

Type: Integer

Default: `1`

## Requirements
- PhoneGap 3.0 or newer / Cordova 3.0 or newer
- Android 2.3.1 or newer / iOS 5 or newer

## Example

```js
var options = {
  date: new Date(),
  mode: 'date'
};

datePicker.show(options, function(date){
  alert("date result " + date);  
});
```

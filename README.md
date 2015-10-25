# DatePicker Plugin for Cordova/PhoneGap 4.0 (iOS and Android and Windows)

This is a combined version of DatePicker iOS and Android and Windows plugin for Cordova/Phonegap 4.0.
- Original iOS version: https://github.com/sectore/phonegap3-ios-datepicker-plugin

- Original Android version: https://github.com/bikasv/cordova-android-plugins/tree/master/datepicker

New in 0.8.0 (Android Only):
- Android code refactored

- Option datetime added (default if mode is unknown), opening a new time dialog after setting the date

- Options okText and cancelText to define the labels for POSITIVE and NEGATIVE buttons

- Option todayText to set the label of a button that selects current date (date and datetime)

- Option nowText to set the label of a button that selects current time (time and datetime)

- Option is24Hour added


## Installation

- Local development workflow using [Cordova CLI](http://cordova.apache.org/docs/en/edge/)

```bash
cordova plugin add cordova-plugin-datepicker
```

- Local development workflow using [PhoneGap CLI](http://phonegap.com/install/)

```bash
phonegap local plugin add cordova-plugin-datepicker
```

- Cloud-based development workflow using [PhoneGap Build](http://build.phonegap.com)

```bash
<gap:plugin name="cordova-plugin-datepicker" source="npm" />
```


## Usage

```js
var options = {
    date: new Date(),
    mode: 'date'
};

function onSuccess(date) {
    alert('Selected date: ' + date);
}

function onError(error) { // Android only
    alert('Error: ' + error);
}

datePicker.show(options, onSuccess, onError);
```

## Options

### mode - iOS, Android, Windows
The mode of the date picker.

Type: String

Values: `date` | `time` | `datetime` (iOS, Windows only)

Default: `date`

### date - iOS, Android, Windows
Selected date.

Type: String

Default: `new Date()`

### minDate - iOS, Android, Windows
Minimum date.

Type: Date | empty String

Default: `(empty String)`

minDate is a Date object for iOS and a millisecond precision unix timestamp for Android, so you need to account for that when using the plugin.

### maxDate - iOS, Android, Windows
Maximum date.

Type: Date | empty String

Default: `(empty String)`

### titleText - Android
Label for the dialog title. If empty, uses android default (Set date/Set time).

Type: String | empty String

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

### androidTheme - Android
Choose the theme of the picker

Type: Int

Values: `THEME_TRADITIONAL | THEME_HOLO_DARK | THEME_HOLO_LIGHT | THEME_DEVICE_DEFAULT_DARK | THEME_DEVICE_DEFAULT_LIGHT`

Default: `THEME_TRADITIONAL`

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

### popoverArrowDirection - iOS
Force the UIPopoverArrowDirection enum.
The value `any` will revert to default `UIPopoverArrowDirectionAny` and let the app choose the proper direction itself.

Values: `up` | `down` | `left` | `right` | `any`

Type: String

Default: `any`

### locale - iOS
Force locale for datePicker.

Type: String

Default: `en_us`

## Requirements
- Cordova 3.0+
- iOS 6.0+
- Android 2.3+

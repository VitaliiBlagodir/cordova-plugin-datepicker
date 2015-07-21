/**
  Phonegap DatePicker Plugin
  https://github.com/sectore/phonegap3-ios-datepicker-plugin

  Copyright (c) Greg Allen 2011
  Additional refactoring by Sam de Freyssinet

  Rewrite by Jens Krause (www.websector.de)

  MIT Licensed
*/

var exec = require('cordova/exec');
/**
 * Constructor
 */
function DatePicker() {
    this._callback;
}

/**
 * Android themes
 * @todo Avoid error when an Android theme is define...
 */
DatePicker.prototype.ANDROID_THEMES = {
  THEME_TRADITIONAL          : 1, // default
  THEME_HOLO_DARK            : 2,
  THEME_HOLO_LIGHT           : 3,
  THEME_DEVICE_DEFAULT_DARK  : 4,
  THEME_DEVICE_DEFAULT_LIGHT : 5
};

/**
 * show - true to show the ad, false to hide the ad
 */
DatePicker.prototype.show = function(options, cb) {
    var padDate = function(date) {
      if (date.length == 1) {
        return ("0" + date);
      }
      return date;
    };

    var formatDate = function(date){
      // date/minDate/maxDate will be string at second time
      if (!(date instanceof Date)) {
        date = new Date(date)
      }
      date = date.getFullYear()
            + "-"
            + padDate(date.getMonth()+1)
            + "-"
            + padDate(date.getDate())
            + "T"
            + padDate(date.getHours())
            + ":"
            + padDate(date.getMinutes())
            + ":00Z";

      return date
    }

    if (options.date) {
        options.date = formatDate(options.date);
    }

    if (options.minDate) {
        options.minDate = formatDate(options.minDate);
    }

    if (options.maxDate) {
        options.maxDate = formatDate(options.maxDate);
    }

    if (options.popoverArrowDirection) {
        options.popoverArrowDirection = this._popoverArrowDirectionIntegerFromString(options.popoverArrowDirection);
        console.log('ha options', this, options.popoverArrowDirection);
    }

    var defaults = {
        mode: 'date',
        date: new Date(),
        allowOldDates: true,
        allowFutureDates: true,
        minDate: '',
        maxDate: '',
        doneButtonLabel: 'Done',
        doneButtonColor: '#007AFF',
        cancelButtonLabel: 'Cancel',
        cancelButtonColor: '#007AFF',
        locale: "NL",
        x: '0',
        y: '0',
        minuteInterval: 1,
        popoverArrowDirection: this._popoverArrowDirectionIntegerFromString("any"),
        locale: "en_US"
    };

    for (var key in defaults) {
        if (typeof options[key] !== "undefined")
            defaults[key] = options[key];
    }
    this._callback = cb;

    exec(null,
      null,
      "DatePicker",
      "show",
      [defaults]
    );
};

DatePicker.prototype._dateSelected = function(date) {
    var d = new Date(parseFloat(date) * 1000);
    if (this._callback)
        this._callback(d);
};

DatePicker.prototype._dateSelectionCanceled = function() {
    if (this._callback)
        this._callback();
};

DatePicker.prototype._UIPopoverArrowDirection = {
    "up": 1,
    "down": 2,
    "left": 4,
    "right": 8,
    "any": 15
};

DatePicker.prototype._popoverArrowDirectionIntegerFromString = function (string) {
    if (typeof this._UIPopoverArrowDirection[string] !== "undefined") {
        return this._UIPopoverArrowDirection[string];
    }
    return this._UIPopoverArrowDirection.any;
};



var datePicker = new DatePicker();
module.exports = datePicker;

// Make plugin work under window.plugins
if (!window.plugins) {
    window.plugins = {};
}
if (!window.plugins.datePicker) {
    window.plugins.datePicker = datePicker;
}

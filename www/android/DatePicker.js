/**
 * Phonegap DatePicker Plugin Copyright (c) Greg Allen 2011 MIT Licensed
 * Reused and ported to Android plugin by Daniel van 't Oever
 */

// var exec = require('cordova/exec');
/**
 * Constructor
 */
function DatePicker() {
  //this._callback;
}

/**
 * show - true to show the ad, false to hide the ad
 */
DatePicker.prototype.show = function(options, cb) {
  
  if (options.date) {
    options.date = (options.date.getMonth() + 1) + "/" + 
                   (options.date.getDate()) + "/" + 
                   (options.date.getFullYear()) + "/" + 
                   (options.date.getHours()) + "/" + 
                   (options.date.getMinutes());
  }

  var defaults = {
    mode : '',
    date : '',
    minDate: 0,
    maxDate: 0
  };

  for (var key in defaults) {
    if (typeof options[key] !== "undefined") {
      defaults[key] = options[key];
    }
  }

  //this._callback = cb;

  var callback = function(message) {
    cb(new Date(message));
  }
  
  cordova.exec(callback, 
    null, 
    "DatePickerPlugin", 
    defaults.mode,
    [defaults]
  );
  
  //return gap.exec(cb, failureCallback, 'DatePickerPlugin', defaults.mode, new Array(defaults));
};

//-------------------------------------------------------------------

if(!window.plugins) {
    window.plugins = {};
}
if (!window.plugins.datePicker) {
    window.plugins.datePicker = new DatePicker();
}

if (module.exports) {
  module.exports = window.plugins.datePicker;
}

/**
 * Phonegap DatePicker Plugin Copyright (c) Greg Allen 2011 MIT Licensed
 * Reused and ported to Android plugin by Daniel van 't Oever
 */

/**
 * Constructor
 */
function DatePicker() {
  //this._callback;
}

/**
 * Android themes
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
DatePicker.prototype.show = function(options, cb, errCb) {

	if (options.date && options.date instanceof Date) {
		options.date = (options.date.getMonth() + 1) + "/" +
					   (options.date.getDate()) + "/" +
					   (options.date.getFullYear()) + "/" +
					   (options.date.getHours()) + "/" +
					   (options.date.getMinutes());
	}

	var defaults = {
		mode : 'date',
		date : '',
		minDate: 0,
		maxDate: 0,
		titleText: '',
		cancelText: '',
		okText: '',
		todayText: '',
		nowText: '',
		is24Hour: false,
    androidTheme : window.datePicker.ANDROID_THEMES.THEME_TRADITIONAL, // Default theme
	};

	for (var key in defaults) {
		if (typeof options[key] !== "undefined") {
			defaults[key] = options[key];
		}
	}

	//this._callback = cb;

	var callback = function(message) {
		if(message != 'error'){
			var timestamp = Date.parse(message);
			if(isNaN(timestamp) == false) {
				cb(new Date(message));
			}
	        else {
	            cb();
	        }
		} else {
			// TODO error popup?
    	}
	}

	var errCallback = function(message) {
		if (typeof errCb === 'function') {
			errCb(message);
		}
	}

	cordova.exec(callback,
		errCallback,
		"DatePickerPlugin",
		defaults.mode,
		[defaults]
	);
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

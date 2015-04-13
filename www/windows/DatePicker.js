/**
* Phonegap DatePicker Plugin Copyright (c) Greg Allen 2011 MIT Licensed
* Reused and ported to Android plugin by Daniel van 't Oever
* Reused and ported to Windows plugin by Thomas Uher
*/
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
		mode : 'date',
		date : '',
		minDate: 0,
		maxDate: 0,
		clearText: 'Clear'
	};
	for (var key in defaults) {
		if (typeof options[key] !== "undefined") {
			defaults[key] = options[key];
		}
	}
	//this._callback = cb;
	var callback = function(message) {
		if(message == -1){
			cb(message);
		} 
		else {
			var timestamp = Date.parse(message);
			if(isNaN(timestamp) == false) {
				cb(new Date(message));
			}
			else {
				cb();
			}
		}
	}
	cordova.exec(callback,
		null,
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
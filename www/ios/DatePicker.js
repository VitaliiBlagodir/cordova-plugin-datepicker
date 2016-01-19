/**
 Phonegap DatePicker Plugin
 https://github.com/sectore/phonegap3-ios-datepicker-plugin

 Copyright (c) Greg Allen 2011
 Additional refactoring by Sam de Freyssinet

 Rewrite by Jens Krause (www.websector.de)

 MIT Licensed
 */

var exec = require( 'cordova/exec' );
/**
 * Constructor
 */
function DatePicker() { }

/**
 * Android themes
 * @todo Avoid error when an Android theme is define...
 */
DatePicker.prototype.ANDROID_THEMES = {
	THEME_TRADITIONAL         : 1, // default
	THEME_HOLO_DARK           : 2,
	THEME_HOLO_LIGHT          : 3,
	THEME_DEVICE_DEFAULT_DARK : 4,
	THEME_DEVICE_DEFAULT_LIGHT: 5
};

/**
 * show - true to show the ad, false to hide the ad
 */
DatePicker.prototype.show = function( options, cb )
{
	if ( options.popoverArrowDirection )
	{
		options.popoverArrowDirection = this._popoverArrowDirectionIntegerFromString( options.popoverArrowDirection );
		console.log( 'ha options', this, options.popoverArrowDirection );
	}

	var defaults = {
		mode                 : options.mode || 'date',
		date                 : formatDate( options.date || new Date() ),
		allowOldDates        : options.allowOldDates || true,
		allowFutureDates     : options.allowFutureDates || true,
		minDate              : options.minDate ? formatDate( options.minDate ) : '',
		maxDate              : options.maxDate ? formatDate( options.maxDate ) : '',
		doneButtonLabel      : options.doneButtonLabel || 'Done',
		doneButtonColor      : options.doneButtonColor || '#007AFF',
		cancelButtonLabel    : options.cancelButtonLabel || 'Cancel',
		cancelButtonColor    : options.cancelButtonColor || '#007AFF',
		x                    : options.x || '0',
		y                    : options.y || '0',
		minuteInterval       : options.minuteInterval || 1,
		popoverArrowDirection: options.popoverArrowDirection || this._popoverArrowDirectionIntegerFromString( "any" ),
		locale               : options.locale || "en_US"
	};
	
	this._callback = cb;

	exec( null, null, "DatePicker", "show", [ defaults ] );






	function padDate( date ) {
		return ( date.length == 1  ? "0" : '') + date;
	}

	function formatDate( date ) {
		// date/minDate/maxDate will be string at second time
		if ( !(date instanceof Date) ) {
			date = new Date( date );
		}


		return [
			date.getFullYear(),
			"-",
			padDate( date.getMonth() + 1 ),
			"-",
			padDate( date.getDate() ),
			"T",
			padDate( date.getHours() ),
			":",
			padDate( date.getMinutes() ),
			":00Z"
		].join( '' );
	}
};

DatePicker.prototype._dateSelected = function( date ) {
	var d = new Date( parseFloat( date ) * 1000 );
	if ( this._callback )
		this._callback( d );
};

DatePicker.prototype._dateSelectionCanceled = function() {
	if ( this._callback )
		this._callback();
};

DatePicker.prototype._UIPopoverArrowDirection = {
	"up"   : 1,
	"down" : 2,
	"left" : 4,
	"right": 8,
	"any"  : 15
};

DatePicker.prototype._popoverArrowDirectionIntegerFromString = function( string ) {
	if ( typeof this._UIPopoverArrowDirection[ string ] !== "undefined" ) {
		return this._UIPopoverArrowDirection[ string ];
	}
	return this._UIPopoverArrowDirection.any;
};


var datePicker = new DatePicker();
module.exports = datePicker;

// Make plugin work under window.plugins
if ( !window.plugins ) {
	window.plugins = {};
}
if ( !window.plugins.datePicker ) {
	window.plugins.datePicker = datePicker;
}

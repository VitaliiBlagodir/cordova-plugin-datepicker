/*
 *
 * Licensed to the Apache Software Foundation (ASF) under one
 * or more contributor license agreements.  See the NOTICE file
 * distributed with this work for additional information
 * regarding copyright ownership.  The ASF licenses this file
 * to you under the Apache License, Version 2.0 (the
 * "License"); you may not use this file except in compliance
 * with the License.  You may obtain a copy of the License at
 *
 *   http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing,
 * software distributed under the License is distributed on an
 * "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
 * KIND, either express or implied.  See the License for the
 * specific language governing permissions and limitations
 * under the License.
 *
*/

/*global Windows:true */

var cordova = require('cordova');

var winJSDatePicker = {
	
	show: function(success, error, pickertype){
		var overlay = document.createElement("div");
		var overlay_id = "winjsdatepickeroverlay";
		overlay.id = overlay_id;
		overlay.style.cssText = "position: fixed; left: 0; top: 0; right:0; bottom:0; width: 100%; height: 100%; z-index: 999; margin: 0 auto; background: #000;";
		
		if (pickertype.indexOf("time") >= 0){
			var timePickerDiv = document.createElement("div");
			timePickerDiv.id = "winjstimepicker";
			var timePicker = new WinJS.UI.TimePicker(timePickerDiv, options);
			timePicker.onchange = module.exports.checkMinMaxTime; 
		
		}
		
		if (pickertype.indexOf("date") >= 0){
			var datePickerDiv = document.createElement("div");
			datePickerDiv.id = "winjsdatepicker";
			var datePicker = new WinJS.UI.DatePicker(datePickerDiv, options);
			datePicker.onchange = module.exports.checkMinMaxDate;
			
			overlay.appendChild(datePickerDiv);
		}
		
		overlayFooter = document.createElement("div");
		overlayFooter.style.cssText = "position: fixed; bottom:0; left:0; right:0; z-index: 1000; width: 100%; height: 10%; display: table; text-align:center; vertical-align:middle;";

		var leftCell = document.createElement("div");
		leftCell.style.cssText = "display: table-cell; width: 50%";
		overlayFooter.appendChild(leftCell);

		var rightCell = document.createElement("div");
		rightCell.style.cssText = "display: table-cell; width: 50%";
		overlayFooter.appendChild(rightCell);

		var cancelButton = document.createElement("button");
		cancelButton.id = "cameraCaptureCancelButton";
		cancelButton.classList.add("cameraButton");
		cancelButton.innerText = "Cancel";
		cancelButton.style.cssText = "width:80%; height: 80%;";
		
		cancelButton.addEventListener("click", function(){
			
			var pickerEl = document.getElementById(overlay_id)
			pickerEl.parentElement.removeChild(pickerEl);
			
		});

		rightCell.appendChild(cancelButton);

		var useButton = document.createElement("button");
		useButton.id = "cameraCaptureTakeButton";
		useButton.classList.add("cameraButton");
		useButton.innerText = "Use";
		useButton.style.cssText = "width:80%; height: 80%;";
		
		useButton.addEventListener("click", success);
		
	},
	
	/* ms only provides maxyear and minyear */
	checkMinMaxDate: function(){
		
	},
	
	checkMinMaxTime : function(){
		
	}
};

module.exports = {
	
    date:function(success, error, args) {
		
		function getDate(){
			var date = new Date(datePicker.current);
			success(date);
		};
		
		winJSDatePicker.show(getDate, error, args);

    },

    time:function(success, error, timeArgs) {
		
		winJSDatePicker.show(getTime, error, args);
		
    },

    datetime:function(success, error, dateTimeArgs) {
		
		winJSDatePicker.show(getDateTime, error, args);

    }
};

require("cordova/exec/proxy").add("DatePicker",module.exports);

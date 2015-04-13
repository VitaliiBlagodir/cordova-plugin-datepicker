cordova.define("com.plugin.datepicker.DatePickerProxy", function(require, exports, module) { /*
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

/*global Windows, WinJS*/

var cordova = require('cordova');

module.exports = {
	
    date: function (success, error, args) {
		
		module.exports.winJSDatePicker.show(success, error, "date", args[0]);

    },

    time: function (success, error, args) {
		
		module.exports.winJSDatePicker.show(success, error, "time", args[0]);
		
    },

    datetime: function (success, error, args) {
		
		module.exports.winJSDatePicker.show(success, error, "datetime", args[0]);

    },

    winJSDatePicker : {
	
        show: function(success, error, pickertype, options){
            /* options = {
            mode : 'date/time/datetime',
            date : selected date in format "month/day/year/hours/minutes",
            minDate: 0 or DateObj,
            maxDate: 0 or DateObj,
            clearText: 'Clear'
            }
            */

            if (options.date) {
                var dateParts = options.date.split("/");

                var month = dateParts[0] <= 9 ? '0' + dateParts[0] : dateParts[0],
                    day = dateParts[1] <= 9 ? '0' + dateParts[1] : dateParts[1],
                    hours = dateParts[3] <= 9 ? '0' + dateParts[3] : dateParts[3],
                    minutes = dateParts[4] <= 9 ? '0' + dateParts[4] : dateParts[4];

                var dateTimeString = "" + dateParts[2] + "-" + month + "-" + day + "T" + hours + ":" + minutes + ":00";

                options.date = new Date(dateTimeString);

            }
            else {
                options.date = new Date();
            }

            if (!options.minDate) {
                options.minDate = new Date ("1970-01-01T00:00:00")
            }

            if (!options.maxDate) {
                options.maxDate = new Date("2050-01-01T00:00:00");
            }
            
            var buttonCSSText = "border: 3px solid white; background:#000; color:#FFF; border-radius:0; width: 90%; height: 90%; font-size: 2em;"

            var overlay = document.createElement("div");
            var overlay_id = "winjsoverlay";
            overlay.id = overlay_id;
            overlay.style.cssText = "position: fixed; left: 0; top: 0; right:0; bottom:0; width: 100%; height: 100%; z-index: 999; margin: 0 auto; background: #000; -ms-touch-action:none;";



            var pickerDivTable = document.createElement("div");
            pickerDivTable.style.cssText = "width:90%; height: 90%; display: table; text-align:center; margin: 0 auto; padding:0;";

            var pickerDiv = document.createElement("div");
            pickerDiv.id = "winjsdatetimepickerContainer";
            pickerDiv.style.cssText = "display: table-cell; vertical-align:middle; text-align:center;";

            pickerDivTable.appendChild(pickerDiv);

            //insert timepicker if needed
            if (pickertype.indexOf("time") >= 0){
                var timePickerTable = document.createElement("table");
                timePickerTable.style.cssText = "table-layout:fixed; width:100%; margin: 0 auto; padding:0;";

                var timePickerDescriptionRow = document.createElement("tr");
                timePickerTable.appendChild(timePickerDescriptionRow);

                var timePickerInputRow = document.createElement("tr");
                timePickerTable.appendChild(timePickerInputRow);

                for (var i = 0; i < 2; i++) {
                    var descriptionElement = document.createElement("td");
                    timePickerDescriptionRow.appendChild(descriptionElement);

                    var cell = document.createElement("td");
                    timePickerInputRow.appendChild(cell);

                    var timePickerSelect = document.createElement("select");
                    timePickerSelect.style.cssText = buttonCSSText;

                    cell.appendChild(timePickerSelect);

                    if (i == 0) {
                        timePickerSelect.id = "winjsdatepickerHours";
                        descriptionElement.textContent = "hours";

                        for (var h = 0; h <= 23; h++) {
                            var option = document.createElement("option");
                            option.textContent = h <= 9 ? "0" + h : h;
                            option.value = h;

                            if (h == options.date.getHours()) {
                                option.setAttribute("selected", "selected");
                            }

                            timePickerSelect.appendChild(option);
                        }
                    }
                    else if (i == 1) {
                        timePickerSelect.id = "winjsdatepickerMinutes";
                        descriptionElement.textContent = "minutes";

                        for (var m = 0 ; m <= 59; m++) {
                            var option = document.createElement("option");
                            option.textContent = m <= 9 ? "0" + m : m;
                            option.value = m;

                            if (m == options.date.getMinutes()) {
                                option.setAttribute("selected", "selected");
                            }

                            timePickerSelect.appendChild(option);
                        }
                    }


                }

                //not supported on phone 8.1
                //var timePicker = new WinJS.UI.TimePicker(timePickerDiv, options);
                
                pickerDiv.appendChild(timePickerTable);
            }

            //insert date picker if needed
            if (pickertype.indexOf("date") >= 0) {

                var datePickerTable = document.createElement("table");
                datePickerTable.style.cssText = "table-layout:fixed; width:100%; margin: 0 auto; padding:0;";

                var datePickerDescriptionRow = document.createElement("tr");
                datePickerTable.appendChild(datePickerDescriptionRow);

                var datePickerInputRow = document.createElement("tr");
                datePickerTable.appendChild(datePickerInputRow);

                for (var i = 0; i < 3; i++) {

                    var descriptionElement = document.createElement("td");
                    datePickerDescriptionRow.appendChild(descriptionElement);

                    var cell = document.createElement("td");

                    var datePickerSelect = document.createElement("select");
                    datePickerSelect.style.cssText = buttonCSSText;

                    if (i == 0) {
                        datePickerSelect.id = "winjsdatepickerYear";
                        descriptionElement.textContent = "year";

                        for (var y=1970; y<=2050; y++) {
                            var option = document.createElement("option");
                            option.textContent = y;
                            option.value = y;

                            if (y == options.date.getFullYear()) {
                                option.setAttribute("selected", "selected");
                            }

                            datePickerSelect.appendChild(option);
                        }

                        
                    }
                    else if (i == 1) {
                        datePickerSelect.id = "winjsdatepickerMonth";
                        descriptionElement.textContent = "month";

                        for (var m=1 ; m<=12; m++) {
                            var option = document.createElement("option");
                            option.textContent = m <=9 ? "0" + m : m;
                            option.value = m;
                            
                            if (m == options.date.getMonth()+1) {
                                option.setAttribute("selected", "selected");
                            }

                            datePickerSelect.appendChild(option);
                        }
                    }
                    else if (i == 2) {
                        datePickerSelect.id = "winjsdatepickerDay";
                        descriptionElement.textContent = "day";

                        for (var d=1; d<=31; d++) {
                            var option = document.createElement("option");
                            option.textContent = d <= 9 ? "0" + d : d;
                            option.value = d;

                            if (d == options.date.getDate()) {
                                option.setAttribute("selected", "selected");
                            }

                            datePickerSelect.appendChild(option);
                        }
                    }

                    datePickerSelect.addEventListener("change", function () {
                        //checkMinMaxDate
                        var year = document.getElementById("winjsdatepickerYear"),
                            month = document.getElementById("winjsdatepickerMonth"),
                            day = document.getElementById("winjsdatepickerDay"),
                            maxYear = options.maxDate.getFullYear(),
                            minYear = options.minDate.getFullYear(),
                            maxMonth = options.maxDate.getMonth()+1,
                            minMonth = options.minDate.getMonth()+1,
                            maxDay = options.maxDate.getDate(),
                            minDay = options.minDate.getDate();


                        if (year.value > maxYear) {
                            year.value = maxYear;
                        }
                        else if (year.value < minYear) {
                            year.value = minYear;
                        }

                        if (year.value == maxYear) {
                            if (month.value > maxMonth) {
                                month.value = maxMonth;
                            }

                            if (month.value == maxMonth) {
                                if (day.value > maxDay) {
                                    day.value = maxDay;
                                }
                            }

                        }
                        else if (year.value == minYear) {
                            if (month.value < minMonth) {
                                month.value = minMonth;
                            }

                            if (month.value == minMonth) {
                                if (day.value < minDay) {
                                    day.value = minDay;
                                }
                            }
                        }

                    }, false);

                    cell.appendChild(datePickerSelect);

                    datePickerInputRow.appendChild(cell);

                }

                pickerDiv.appendChild(datePickerTable);
                //not supported on phone 8.1
                //var datePicker = new WinJS.UI.DatePicker(datePickerDiv, options);
                //datePicker.onchange = module.exports.checkMinMaxDate;

            }

            overlay.appendChild(pickerDivTable);

            overlayFooter = document.createElement("div");
            overlayFooter.style.cssText = "position: fixed; bottom:0; left:0; right:0; z-index: 1000; width: 100%; height: 10%; display: table; text-align:center; vertical-align:middle;";
            overlay.appendChild(overlayFooter);

            var leftCell = document.createElement("div");
            leftCell.style.cssText = "display: table-cell; width: 50%";
            overlayFooter.appendChild(leftCell);

            var rightCell = document.createElement("div");
            rightCell.style.cssText = "display: table-cell; width: 50%";
            overlayFooter.appendChild(rightCell);

            var cancelButton = document.createElement("button");
            cancelButton.innerText = "Cancel";
            cancelButton.style.cssText = buttonCSSText;

            cancelButton.addEventListener("click", function(){
			
                overlay.parentElement.removeChild(overlay);
			
            });

            rightCell.appendChild(cancelButton);

            var useButton = document.createElement("button");
            useButton.innerText = "Use";
            useButton.style.cssText = buttonCSSText;
		
            useButton.addEventListener("click", function () {
                //read input and return Date Object
                var year = document.getElementById("winjsdatepickerYear"),
                    month = document.getElementById("winjsdatepickerMonth"),
                    day = document.getElementById("winjsdatepickerDay"),
                    hours = document.getElementById("winjsdatepickerHours"),
                    minutes = document.getElementById("winjsdatepickerMinutes");

                var dateTimeStr = "";

                if (pickertype.indexOf("date") >= 0) {
                    dateTimeStr = "" + (year.value <= 9 ? "0" + year.value : year.value) + "-" + (month.value <= 9 ? "0" + month.value : month.value) + "-" + (day.value <= 9 ? "0" + day.value : day.value);
                }
                else {
                    dateTimeStr = "1970-01-01";
                }

                if (pickertype.indexOf("time") >= 0) {
                    dateTimeStr = dateTimeStr + "T" + (hours.value <= 9 ? "0" + hours.value : hours.value) + ":" + (minutes.value <= 9 ? "0" + minutes.value : minutes.value) + ":00";
                }
                
                overlay.parentElement.removeChild(overlay);
                success(dateTimeStr);


            });

            leftCell.appendChild(useButton);

            document.body.appendChild(overlay);
            
        }
    }
};

require("cordova/exec/proxy").add("DatePickerPlugin",module.exports);

});

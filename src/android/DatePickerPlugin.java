/**
 * @author Bikas Vaibhav (http://bikasv.com) 2013
 * Rewrote the plug-in at https://github.com/phonegap/phonegap-plugins/tree/master/Android/DatePicker
 * It can now accept `min` and `max` dates for DatePicker.
 */

package com.plugin.datepicker;

import java.util.Calendar;
import java.util.Date;
import java.util.TimeZone;
import java.text.SimpleDateFormat;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import android.annotation.SuppressLint;
import android.app.DatePickerDialog;
import android.app.DatePickerDialog.OnDateSetListener;
import android.app.Dialog;
import android.app.TimePickerDialog;
import android.app.TimePickerDialog.OnTimeSetListener;
import android.content.Context;
import android.content.DialogInterface;
import android.util.Log;
import android.view.KeyEvent;
import android.widget.DatePicker;
import android.widget.DatePicker.OnDateChangedListener;
import android.widget.TimePicker;

import org.apache.cordova.CordovaWebView;
import org.apache.cordova.CallbackContext;
import org.apache.cordova.CordovaPlugin;

import android.os.Build;

@SuppressWarnings("deprecation")
@SuppressLint("NewApi")
public class DatePickerPlugin extends CordovaPlugin {

	private static final String ACTION_DATE = "date";
	private static final String ACTION_TIME = "time";
	private final String pluginName = "DatePickerPlugin";

	@Override
	public boolean execute(final String action, final JSONArray data, final CallbackContext callbackContext) {
		Log.d(pluginName, "DatePicker called with options: " + data);
		boolean result = false;

		this.show(data, callbackContext);
		result = true;

		return result;
	}

	public synchronized void show(final JSONArray data, final CallbackContext callbackContext) {
		final DatePickerPlugin datePickerPlugin = this;
		final Context currentCtx = cordova.getActivity();
		final Calendar c = Calendar.getInstance();
		final Runnable runnable;

		String action = "date";
		long minDateLong = 0, maxDateLong = 0;

		int month = -1, day = -1, year = -1, hour = -1, min = -1;
		try {
			JSONObject obj = data.getJSONObject(0);
			action = obj.getString("mode");

			String optionDate = obj.getString("date");

			String[] datePart = optionDate.split("/");
			month = Integer.parseInt(datePart[0]);
			day = Integer.parseInt(datePart[1]);
			year = Integer.parseInt(datePart[2]);
			hour = Integer.parseInt(datePart[3]);
			min = Integer.parseInt(datePart[4]);

			minDateLong = obj.getLong("minDate");
			maxDateLong = obj.getLong("maxDate");

		} catch (JSONException e) {
			e.printStackTrace();
		}

		// By default initalize these fields to 'now'
		final int mYear = year == -1 ? c.get(Calendar.YEAR) : year;
		final int mMonth = month == -1 ? c.get(Calendar.MONTH) : month - 1;
		final int mDay = day == -1 ? c.get(Calendar.DAY_OF_MONTH) : day;
		final int mHour = hour == -1 ? c.get(Calendar.HOUR_OF_DAY) : hour;
		final int mMinutes = min == -1 ? c.get(Calendar.MINUTE) : min;

		final long minDate = minDateLong;
		final long maxDate = maxDateLong;

		if (ACTION_TIME.equalsIgnoreCase(action)) {
			runnable = new Runnable() {
				@Override
				public void run() {
					final TimeSetListener timeSetListener = new TimeSetListener(datePickerPlugin, callbackContext);
					final TimePickerDialog timeDialog = new TimePickerDialog(currentCtx, timeSetListener, mHour,
							mMinutes, false);
					if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.HONEYCOMB) {
						timeDialog.setCancelable(true);
						timeDialog.setCanceledOnTouchOutside(false);
						timeDialog.setButton(DialogInterface.BUTTON_NEGATIVE, currentCtx.getString(android.R.string.cancel), new DialogInterface.OnClickListener() {
							@Override
							public void onClick(DialogInterface dialog, int which) {
								callbackContext.success("cancel");
							}
						});
						timeDialog.setOnKeyListener(new Dialog.OnKeyListener() {
							@Override
							public boolean onKey(DialogInterface dialog, int keyCode, KeyEvent event) {
								// TODO Auto-generated method stub
								//callbackContext.success("");
								return false;
							}
						});
					}
					timeDialog.show();
				}
			};

		} else if (ACTION_DATE.equalsIgnoreCase(action)) {
			runnable = new Runnable() {
				@Override
				public void run() {
					final DateSetListener dateSetListener = new DateSetListener(datePickerPlugin, callbackContext);
					final DatePickerDialog dateDialog = new DatePickerDialog(currentCtx, dateSetListener, mYear,
							mMonth, mDay);
					if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.HONEYCOMB) {
						DatePicker dp = dateDialog.getDatePicker();
						if(minDate > 0) {
							dp.setMinDate(minDate);
						}
						if(maxDate > 0 && maxDate > minDate) {
							dp.setMaxDate(maxDate);
						}

						dateDialog.setCancelable(true);
						dateDialog.setCanceledOnTouchOutside(false);
						dateDialog.setButton(DialogInterface.BUTTON_NEGATIVE, currentCtx.getString(android.R.string.cancel), new DialogInterface.OnClickListener() {
				            @Override
				            public void onClick(DialogInterface dialog, int which) {
								callbackContext.success("cancel");
				            }
				        });
						dateDialog.setOnKeyListener(new Dialog.OnKeyListener() {
							@Override
							public boolean onKey(DialogInterface dialog, int keyCode, KeyEvent event) {
								// TODO Auto-generated method stub
								//callbackContext.success("");
								return false;
							}
						});
					}
					else {
						java.lang.reflect.Field mDatePickerField = null;
						try {
							mDatePickerField = dateDialog.getClass().getDeclaredField("mDatePicker");
						} catch (NoSuchFieldException e) {
							// TODO Auto-generated catch block
							e.printStackTrace();
						}
						mDatePickerField.setAccessible(true);
						DatePicker pickerView = null;
						try {
							pickerView = (DatePicker) mDatePickerField.get(dateDialog);
						} catch (IllegalArgumentException e) {
							e.printStackTrace();
						} catch (IllegalAccessException e) {
							e.printStackTrace();
						}

						final Calendar startDate = Calendar.getInstance();
						startDate.setTimeInMillis(minDate);
						final Calendar endDate = Calendar.getInstance();
						endDate.setTimeInMillis(maxDate);

						final int minYear = startDate.get(Calendar.YEAR);
					    final int minMonth = startDate.get(Calendar.MONTH);
					    final int minDay = startDate.get(Calendar.DAY_OF_MONTH);
					    final int maxYear = endDate.get(Calendar.YEAR);
					    final int maxMonth = endDate.get(Calendar.MONTH);
					    final int maxDay = endDate.get(Calendar.DAY_OF_MONTH);

						if(startDate !=null || endDate != null) {
							pickerView.init(mYear, mMonth, mDay, new OnDateChangedListener() {
				                @Override
								public void onDateChanged(DatePicker view, int year, int month, int day) {
				                	if(maxDate > 0 && maxDate > minDate) {
					                	if(year > maxYear || month > maxMonth && year == maxYear || day > maxDay && year == maxYear && month == maxMonth){
					                		view.updateDate(maxYear, maxMonth, maxDay);
					                	}
				                	}
				                	if(minDate > 0) {
					                	if(year < minYear || month < minMonth && year == minYear || day < minDay && year == minYear && month == minMonth) {
					                		view.updateDate(minYear, minMonth, minDay);
					                	}
				                	}
			                	}
				            });
						}
					}
					dateDialog.show();
				}
			};

		} else {
			Log.d(pluginName, "Unknown action. Only 'date' or 'time' are valid actions");
			return;
		}

		cordova.getActivity().runOnUiThread(runnable);
	}

	private final class DateSetListener implements OnDateSetListener {
		private final DatePickerPlugin datePickerPlugin;
		private final CallbackContext callbackContext;

		private DateSetListener(DatePickerPlugin datePickerPlugin, CallbackContext callbackContext) {
			this.datePickerPlugin = datePickerPlugin;
			this.callbackContext = callbackContext;
		}

		/**
		 * Return a string containing the date in the format YYYY/MM/DD
		 */
		@Override
		public void onDateSet(final DatePicker view, final int year, final int monthOfYear, final int dayOfMonth) {
			String returnDate = year + "/" + (monthOfYear + 1) + "/" + dayOfMonth;
			callbackContext.success(returnDate);
		}
	}

	private final class TimeSetListener implements OnTimeSetListener {
		private final DatePickerPlugin datePickerPlugin;
		private final CallbackContext callbackContext;

		private TimeSetListener(DatePickerPlugin datePickerPlugin, CallbackContext callbackContext) {
			this.datePickerPlugin = datePickerPlugin;
			this.callbackContext = callbackContext;
		}

		/**
		 * Return the current date with the time modified as it was set in the
		 * time picker.
		 */
		@Override
		public void onTimeSet(final TimePicker view, final int hourOfDay, final int minute) {
			Calendar calendar = Calendar.getInstance(TimeZone.getDefault());
			calendar.set(Calendar.HOUR_OF_DAY, hourOfDay);
			calendar.set(Calendar.MINUTE, minute);

			SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd'T'HH:mm:ss'Z'");
			sdf.setTimeZone(TimeZone.getTimeZone("GMT"));
			String toReturn = sdf.format(calendar.getTime());

			callbackContext.success(toReturn);
		}
	}

}

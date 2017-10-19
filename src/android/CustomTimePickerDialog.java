package com.plugin.datepicker;

import java.lang.reflect.Field;
import java.util.ArrayList;
import java.util.List;

import android.app.TimePickerDialog;
import android.content.Context;
import android.content.DialogInterface;
import android.widget.NumberPicker;
import android.widget.TimePicker;
import android.os.Bundle;

public class CustomTimePickerDialog extends TimePickerDialog {

    final OnTimeSetListener mCallback;
    TimePicker mTimePicker;
    final int increment;
    final int theme;
    private int minHour = 0;
    private int maxHour = 24;
    private int minMinute = 0;
    private int maxMinute = 60;

    public int getMinHour() {
        return minHour;
    }

    public void setMinHour(int minHour) {
        this.minHour = minHour;
    }

    public void setMaxHour(int maxHour) {
        this.maxHour = maxHour;
    }

    public void setMinMinute(int minMinute) {
        this.minMinute = minMinute;
    }

    public void setMaxMinute(int maxMinute) {
        this.maxMinute = maxMinute;
    }

    public CustomTimePickerDialog(Context context, int theme, OnTimeSetListener callBack, int hourOfDay, int minute, boolean is24HourView, int increment)
    {
        super(context, theme, callBack, hourOfDay, minute/increment, is24HourView);
        this.mCallback = callBack;
        this.increment = increment;
        this.theme = theme;
    }

    @Override
    public void onClick(DialogInterface dialog, int which) {
        if (mCallback != null && mTimePicker!=null) {
            mTimePicker.clearFocus();
            int minutes = theme != 2 ? mTimePicker.getCurrentMinute(): mTimePicker.getCurrentMinute()*increment;
            mCallback.onTimeSet(mTimePicker, mTimePicker.getCurrentHour(),
                    minutes);
        }
    }

    @Override
    public void updateTime(int hourOfDay, int minuteOfHour) {
        mTimePicker.setCurrentHour(hourOfDay);
        mTimePicker.setCurrentMinute((minuteOfHour-minMinute)/increment);
    }

    public void updateTimeClock(int hourOfDay, int minuteOfHour) {
        if(minuteOfHour == maxMinute){
            minuteOfHour = 0;
        }
        mTimePicker.setCurrentHour(hourOfDay);
        mTimePicker.setCurrentMinute(minuteOfHour);
    }

    @Override
    protected void onStop()
    {
        // override and do nothing
    }

    private void setHourSpinner(TimePicker timePicker, Field hour) throws IllegalAccessException{
        NumberPicker mHourSpinner = (NumberPicker)timePicker.findViewById(hour.getInt(null));
        mHourSpinner.setMinValue(minHour);
        mHourSpinner.setMaxValue(maxHour-1);
        List<String> displayedHoursValues = new ArrayList<String>();
        for(int i=minHour;i<maxHour;i+=1)
        {
            displayedHoursValues.add(String.format("%02d", i));
        }
        mHourSpinner.setDisplayedValues(displayedHoursValues.toArray(new String[0]));
    }

    private void setMinuteSpinner(TimePicker timePicker, Field minute) throws IllegalAccessException{
        NumberPicker mMinuteSpinner = (NumberPicker)timePicker.findViewById(minute.getInt(null));
        int newMin = (minMinute/increment) * increment;
        mMinuteSpinner.setMinValue(minMinute/increment);
        mMinuteSpinner.setMaxValue((maxMinute/increment)-1);
        List<String> displayedMinutesValues = new ArrayList<String>();
        for(int i=newMin;i<maxMinute;i+=increment)
        {
            displayedMinutesValues.add(String.format("%02d", i));
        }
        mMinuteSpinner.setDisplayedValues(displayedMinutesValues.toArray(new String[0]));
    }

    @Override
    protected void onCreate(Bundle savedInstanceState)
    {
        super.onCreate(savedInstanceState);
        try
        {
            Class<?> rClass = Class.forName("com.android.internal.R$id");
            Field timePicker = rClass.getField("timePicker");
            this.mTimePicker = (TimePicker)findViewById(timePicker.getInt(null));
            Field m = rClass.getField("minute");
            Field h = rClass.getField("hour");

            setHourSpinner(this.mTimePicker, h);
            setMinuteSpinner(this.mTimePicker, m);
        }
        catch (Exception e)
        {
            e.printStackTrace();
        }
    }
}

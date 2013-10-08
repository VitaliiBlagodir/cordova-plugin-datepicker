/*
  Phonegap DatePicker Plugin
  https://github.com/sectore/phonegap3-ios-datepicker-plugin  
  
  Copyright (c) Greg Allen 2011
  Additional refactoring by Sam de Freyssinet
  
  Rewrite by Jens Krause (www.websector.de)

  MIT Licensed
*/

#import "DatePicker.h"
#import <Cordova/CDV.h>

@interface DatePicker ()

@property (nonatomic) BOOL isVisible;
@property (nonatomic) UIActionSheet* datePickerSheet;
@property (nonatomic) UIDatePicker* datePicker;
@property (nonatomic) UIPopoverController *datePickerPopover;

@end

@implementation DatePicker

#pragma mark - UIDatePicker

- (void)show:(CDVInvokedUrlCommand*)command {
  NSMutableDictionary *options = [command argumentAtIndex:0];
  if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
    [self showForPhone: options];
  } else {
    [self showForPad: options];
  }   
}

- (BOOL)showForPhone:(NSMutableDictionary *)options {
  if(!self.isVisible){
    self.datePickerSheet = [self createActionSheet:options];
    self.isVisible = TRUE;
  }
  return true;
}

- (BOOL)showForPad:(NSMutableDictionary *)options {
  if(!self.isVisible){
    self.datePickerPopover = [self createPopover:options];
    self.isVisible = TRUE;
  }
  return true;    
}

- (void)hide {
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        [self.datePickerSheet dismissWithClickedButtonIndex:0 animated:YES];
    } else {
        [self.datePickerPopover dismissPopoverAnimated:YES];
    }
}

- (void)doneAction:(id)sender {
  [self jsDateSelected];
  [self hide];
}


- (void)cancelAction:(id)sender {
  [self hide];
}


- (void)dateChangedAction:(id)sender {
  [self jsDateSelected];
}

#pragma mark - JS API

- (void)jsDateSelected {
  NSTimeInterval seconds = [self.datePicker.date timeIntervalSince1970];
  NSString* jsCallback = [NSString stringWithFormat:@"datePicker._dateSelected(\"%f\");", seconds];
  [super writeJavascript:jsCallback];
}


#pragma mark - UIActionSheetDelegate methods

- (void)actionSheet:(UIActionSheet *)actionSheet willDismissWithButtonIndex:(NSInteger)buttonIndex {

}

- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex {
    self.isVisible = FALSE;
}


#pragma mark - UIPopoverControllerDelegate methods

- (void)popoverControllerDidDismissPopover:(UIPopoverController *)popoverController {
  self.isVisible = FALSE;   
}

#pragma mark - Factory methods

- (UIActionSheet *)createActionSheet:(NSMutableDictionary *)options {
  UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil
                                                        delegate:self cancelButtonTitle:nil
                                                        destructiveButtonTitle:nil 
                                                        otherButtonTitles:nil];

  [actionSheet setActionSheetStyle:UIActionSheetStyleBlackTranslucent];
  // date picker
  CGRect frame = CGRectMake(0, 40, 0, 0);
  if(!self.datePicker){
    self.datePicker = [self createDatePicker: options frame:frame];
  } 
  [self updateDatePicker:options];
  [actionSheet addSubview: self.datePicker];
  // cancel button
  UISegmentedControl *cancelButton = [self createCancelButton:options];
  [actionSheet addSubview:cancelButton];
  // done button
  UISegmentedControl *doneButton = [self createDoneButton:options];    
  [actionSheet addSubview:doneButton];
  // show UIActionSheet
  [actionSheet showInView:self.webView.superview];
  [actionSheet setBounds:CGRectMake(0, 0, 320, 485)];

  return actionSheet;
}

- (UIPopoverController *)createPopover:(NSMutableDictionary *)options {
    
  CGFloat pickerViewWidth = 320.0f;
  CGFloat pickerViewHeight = 216.0f;
  UIView *datePickerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, pickerViewWidth, pickerViewHeight)];

  CGRect frame = CGRectMake(0, 0, 0, 0);
  if(!self.datePicker){
    self.datePicker = [self createDatePicker:options frame:frame];
    [self.datePicker addTarget:self action:@selector(dateChangedAction:) forControlEvents:UIControlEventValueChanged];    
  }
  [self updateDatePicker:options]; 
  [datePickerView addSubview:self.datePicker];

  UIViewController *datePickerViewController = [[UIViewController alloc]init];
  datePickerViewController.view = datePickerView;
  
  UIPopoverController *popover = [[UIPopoverController alloc] initWithContentViewController:datePickerViewController];
  popover.delegate = self;
  [popover setPopoverContentSize:CGSizeMake(pickerViewWidth, pickerViewHeight) animated:NO];
  
  CGFloat x = [[options objectForKey:@"x"] intValue];
  CGFloat y = [[options objectForKey:@"y"] intValue];
  CGRect anchor = CGRectMake(x, y, 1, 1);
  [popover presentPopoverFromRect:anchor inView:self.webView.superview  permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];   
  
  return popover;
}

- (UIDatePicker *)createDatePicker:(NSMutableDictionary *)options frame:(CGRect)frame { 
  UIDatePicker *datePicker = [[UIDatePicker alloc] initWithFrame:frame];      
  return datePicker;
}

- (void)updateDatePicker:(NSMutableDictionary *)options {
  NSDateFormatter *formatter = [self createISODateFormatter:k_DATEPICKER_DATETIME_FORMAT timezone:[NSTimeZone defaultTimeZone]];
  NSString *mode = [options objectForKey:@"mode"];
  NSString *dateString = [options objectForKey:@"date"];
  BOOL allowOldDates = NO;
  BOOL allowFutureDates = YES;
  NSString *minDateString = [options objectForKey:@"minDate"];
  NSString *maxDateString = [options objectForKey:@"maxDate"];
    
  if ([[options objectForKey:@"allowOldDates"] intValue] == 1) {
    allowOldDates = YES;
  }
    
  if ( !allowOldDates) {
    self.datePicker.minimumDate = [NSDate date];
  }
    
  if(minDateString){
    self.datePicker.minimumDate = [formatter dateFromString:minDateString];
  }
  
  if ([[options objectForKey:@"allowFutureDates"] intValue] == 0) {
    allowFutureDates = NO;
  }
    
  if ( !allowFutureDates) {
    self.datePicker.maximumDate = [NSDate date];
  }
    
  if(maxDateString){
    self.datePicker.maximumDate = [formatter dateFromString:maxDateString];
  }
    
  self.datePicker.date = [formatter dateFromString:dateString];
    
  if ([mode isEqualToString:@"date"]) {
    self.datePicker.datePickerMode = UIDatePickerModeDate;
  }
  else if ([mode isEqualToString:@"time"]) {
    self.datePicker.datePickerMode = UIDatePickerModeTime;
  } else {
    self.datePicker.datePickerMode = UIDatePickerModeDateAndTime;
  }
}

- (NSDateFormatter *)createISODateFormatter:(NSString *)format timezone:(NSTimeZone *)timezone {
  NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
  [dateFormatter setTimeZone:timezone];
  [dateFormatter setDateFormat:format];

  return dateFormatter;
}


- (UISegmentedControl *)createCancelButton:(NSMutableDictionary *)options {
  NSString *label = [options objectForKey:@"cancelButtonLabel"];
  UISegmentedControl *button = [[UISegmentedControl alloc] initWithItems:[NSArray arrayWithObject:label]];

  NSString *tintColorHex = [options objectForKey:@"cancelButtonColor"];
  button.tintColor = [self colorFromHexString: tintColorHex];  
    
  button.momentary = YES;
  button.segmentedControlStyle = UISegmentedControlStyleBar;
  button.apportionsSegmentWidthsByContent = YES;
  
  CGSize size = button.bounds.size;
  button.frame = CGRectMake(5, 7.0f, size.width, size.height);
  
  [button addTarget:self action:@selector(cancelAction:) forControlEvents:UIControlEventValueChanged];
    
  return button;
}

- (UISegmentedControl *)createDoneButton:(NSMutableDictionary *)options {
  NSString *label = [options objectForKey:@"doneButtonLabel"];
  UISegmentedControl *button = [[UISegmentedControl alloc] initWithItems:[NSArray arrayWithObject:label]];
  NSString *tintColorHex = [options objectForKey:@"doneButtonColor"];
  button.tintColor = [self colorFromHexString: tintColorHex];

  button.momentary = YES;
  button.segmentedControlStyle = UISegmentedControlStyleBar;
  button.apportionsSegmentWidthsByContent = YES;
    
  CGSize size = button.bounds.size;
  CGFloat width = size.width;
  CGFloat height = size.height;
  CGFloat xPos = 320 - width - 5; // 320 == width of DatePicker, 5 == offset to right side hand
  button.frame = CGRectMake(xPos, 7.0f, width, height);
  
  [button addTarget:self action:@selector(doneAction:) forControlEvents:UIControlEventValueChanged];

  return button;
}

// Helper method to convert a hex string into UIColor
// @see: http://stackoverflow.com/questions/1560081/how-can-i-create-a-uicolor-from-a-hex-string
- (UIColor *)colorFromHexString:(NSString *)hexString {
    unsigned rgbValue = 0;
    NSScanner *scanner = [NSScanner scannerWithString:hexString];
    [scanner setScanLocation:1]; // bypass '#' character
    [scanner scanHexInt:&rgbValue];
    return [UIColor colorWithRed:((rgbValue & 0xFF0000) >> 16)/255.0 green:((rgbValue & 0xFF00) >> 8)/255.0 blue:(rgbValue & 0xFF)/255.0 alpha:1.0];
}

@end
/*
 
 Phonegap DatePicker Plugin for using Cordova 3 and iOS 7
 https://github.com/sectore/phonegap3-ios-datepicker-plugin
 
 Based on a previous plugin version by Greg Allen and Sam de Freyssinet.
 
 Rewrite by Jens Krause (www.websector.de)
 
 MIT Licensed
 
 */

#import "DatePicker.h"
#import <Cordova/CDV.h>

@interface DatePicker ()

@property (nonatomic) UIPopoverController *datePickerPopover;

@property (nonatomic) IBOutlet UIView* datePickerContainer;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *datePickerComponentsContainerVSpace;
@property (nonatomic) IBOutlet UIView* datePickerComponentsContainer;
@property (nonatomic) IBOutlet UIButton *cancelButton;
@property (nonatomic) IBOutlet UIButton *doneButton;
@property (nonatomic) IBOutlet UIDatePicker *datePicker;

@end

@implementation DatePicker

#define isIPhone (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
#define ANIMATION_DURATION 0.3

#pragma mark - UIDatePicker

- (void)show:(CDVInvokedUrlCommand*)command {
  NSMutableDictionary *options = [command argumentAtIndex:0];
  //if (isIPhone) {
    [self showForPhone: options];
  //} else {
 //   [self showForPad: options];
 // }
}

- (BOOL)showForPhone:(NSMutableDictionary *)options {
  if(!self.datePickerContainer){
    [[NSBundle mainBundle] loadNibNamed:@"DatePicker" owner:self options:nil];
  } else {
      self.datePickerContainer.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.4];
  }
  
  [self updateDatePicker:options];
  [self updateCancelButton:options];
  [self updateDoneButton:options];
  
  UIInterfaceOrientation deviceOrientation = [UIApplication sharedApplication].statusBarOrientation;
  
  CGFloat width;
  CGFloat height;
  
  [self.datePickerContainer removeFromSuperview];
  
  if(UIInterfaceOrientationIsLandscape(deviceOrientation)){
    width = self.webView.superview.frame.size.width;
    height= self.webView.superview.frame.size.height;
  } else {
    width = self.webView.superview.frame.size.width;
    height= self.webView.superview.frame.size.height;
  }

  NSLog(@"%.2f", width);
  NSLog(@"%.2f", height);

  self.datePickerContainer.frame = CGRectMake(0, 0, width, height);
  
  [self.webView.superview addSubview: self.datePickerContainer];
  [self.datePickerContainer layoutIfNeeded];

  CGRect frame = self.datePickerComponentsContainer.frame;
  self.datePickerComponentsContainer.frame = CGRectOffset(frame,
                                                          0,
                                                          frame.size.height );
  
  
  self.datePickerContainer.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0];
  
  [UIView animateWithDuration:ANIMATION_DURATION
                        delay:0
                      options:UIViewAnimationOptionCurveEaseOut
                   animations:^{
    self.datePickerComponentsContainer.frame = frame;
    self.datePickerContainer.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.4];

  } completion:^(BOOL finished) {
    
  }];
  
  return true;
}

- (BOOL)showForPad:(NSMutableDictionary *)options {
    self.datePickerPopover = [self createPopover:options];
    return true;
}

- (void)hide {
  //if (isIPhone) {
    CGRect frame = CGRectOffset(self.datePickerComponentsContainer.frame,
                                0,
                                self.datePickerComponentsContainer.frame.size.height);
    
    [UIView animateWithDuration:ANIMATION_DURATION
                          delay:0
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
                       self.datePickerComponentsContainer.frame = frame;
                       self.datePickerContainer.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0];
                       
                     } completion:^(BOOL finished) {
                       [self.datePickerContainer removeFromSuperview];
                     }];

 // } else {
 //   [self.datePickerPopover dismissPopoverAnimated:YES];
 // }
}

#pragma mark - Actions
- (IBAction)doneAction:(id)sender {
  [self jsDateSelected];
  [self hide];
}
  
- (IBAction)cancelAction:(id)sender {
  [self jsCancel];
  [self hide];
}


- (void)dateChangedAction:(id)sender {
  [self jsDateSelected];
}

#pragma mark - JS API

- (void)jsCancel {
  NSLog(@"JS Cancel is going to be executed");
  NSString *jsCallback = @"datePicker._dateSelectionCanceled();";
    
  [self.commandDelegate evalJs:jsCallback];
}

- (void)jsDateSelected {
  NSTimeInterval seconds = [self.datePicker.date timeIntervalSince1970];
  NSString *jsCallback = [NSString stringWithFormat:@"datePicker._dateSelected(\"%f\");", seconds];
    
  [self.commandDelegate evalJs:jsCallback];
}


#pragma mark - UIPopoverControllerDelegate methods

- (void)popoverControllerDidDismissPopover:(UIPopoverController *)popoverController {
  [self jsDateSelected];
}

#pragma mark - Factory methods

- (UIPopoverController *)createPopover:(NSMutableDictionary *)options {
  
  CGFloat pickerViewWidth = 320.0f;
  CGFloat pickerViewHeight = 216.0f;
  UIView *datePickerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, pickerViewWidth, pickerViewHeight)];
  
  CGRect frame = CGRectMake(0, 0, 0, 0);
  // in iOS8, UIDatePicker couldn't be shared in multi UIViews, it will cause crash. so   create new UIDatePicker instance every time
  if (! self.datePicker || [[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0){
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
  UIPopoverArrowDirection arrowDirection = [[options objectForKey:@"popoverArrowDirection"] intValue];
  
  CGRect anchor = CGRectMake(x, y, 1, 1);
  [popover presentPopoverFromRect:anchor inView:self.webView.superview  permittedArrowDirections:arrowDirection animated:YES];
  
  return popover;
}

- (UIDatePicker *)createDatePicker:(NSMutableDictionary *)options frame:(CGRect)frame {
  UIDatePicker *datePicker = [[UIDatePicker alloc] initWithFrame:frame];
  return datePicker;
}

#define DATETIME_FORMAT @"yyyy-MM-dd'T'HH:mm:ss'Z'"

- (void)updateDatePicker:(NSMutableDictionary *)options {
  NSDateFormatter *formatter = [self createISODateFormatter: DATETIME_FORMAT timezone:[NSTimeZone defaultTimeZone]];
  NSString *mode = [options objectForKey:@"mode"];
  NSString *dateString = [options objectForKey:@"date"];
  BOOL allowOldDates = ([[options objectForKey:@"allowOldDates"] intValue] == 0) ? NO : YES;
  BOOL allowFutureDates = ([[options objectForKey:@"allowFutureDates"] intValue] == 0) ? NO : YES;
  NSString *minDateString = [options objectForKey:@"minDate"];
  NSString *maxDateString = [options objectForKey:@"maxDate"];
  NSString *minuteIntervalString = [options objectForKey:@"minuteInterval"];
  NSInteger minuteInterval = [minuteIntervalString integerValue];
  NSLocale *locale = [[NSLocale alloc] initWithLocaleIdentifier:[options objectForKey:@"locale"]];

  
  if (allowOldDates) {
    self.datePicker.minimumDate = nil;
  }
  else {
    self.datePicker.minimumDate = [NSDate date];
  }
  
  if(minDateString && minDateString.length > 0){
    self.datePicker.minimumDate = [formatter dateFromString:minDateString];
  }
  
  if (allowFutureDates) {
    self.datePicker.maximumDate = nil;
  }
  else {
    self.datePicker.maximumDate = [NSDate date];
  }
  
  if(maxDateString && maxDateString.length > 0){
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

  if (minuteInterval) {
    self.datePicker.minuteInterval = minuteInterval;
  }

  if (locale) {
    [self.datePicker setLocale:locale];
  }
}

- (NSDateFormatter *)createISODateFormatter:(NSString *)format timezone:(NSTimeZone *)timezone {
  NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
  // Locale needed to avoid formatter bug on phones set to 12-hour
  // time to avoid it adding AM/PM to the string we supply
  // See: http://stackoverflow.com/questions/6613110/what-is-the-best-way-to-deal-with-the-nsdateformatter-locale-feature
  NSLocale *loc = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];
  [dateFormatter setLocale: loc];
  [dateFormatter setTimeZone:timezone];
  [dateFormatter setDateFormat:format];
  
  return dateFormatter;
}

- (void)updateCancelButton:(NSMutableDictionary *)options {

  NSString *label = [options objectForKey:@"cancelButtonLabel"];
  [self.cancelButton setTitle:label forState:UIControlStateNormal];
  
  NSString *tintColorHex = [options objectForKey:@"cancelButtonColor"];
  self.cancelButton.tintColor = [self colorFromHexString: tintColorHex];
  
}

- (void)updateDoneButton:(NSMutableDictionary *)options {
  
  NSString *label = [options objectForKey:@"doneButtonLabel"];
  [self.doneButton setTitle:label forState:UIControlStateNormal];
  
  NSString *tintColorHex = [options objectForKey:@"doneButtonColor"];
  [self.doneButton setTintColor: [self colorFromHexString: tintColorHex]];
  
}


#pragma mark - Utilities

/*! Converts a hex string into UIColor
 It based on http://stackoverflow.com/questions/1560081/how-can-i-create-a-uicolor-from-a-hex-string
 
  @param hexString The hex string which has to be converted
 */
- (UIColor *)colorFromHexString:(NSString *)hexString {
  unsigned rgbValue = 0;
  NSScanner *scanner = [NSScanner scannerWithString:hexString];
  [scanner setScanLocation:1]; // bypass '#' character
  [scanner scanHexInt:&rgbValue];
  return [UIColor colorWithRed:((rgbValue & 0xFF0000) >> 16)/255.0 green:((rgbValue & 0xFF00) >> 8)/255.0 blue:(rgbValue & 0xFF)/255.0 alpha:1.0];
}

@end

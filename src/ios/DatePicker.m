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
- (IBAction)didDismissWithCancelButton:(id)sender {
    
    // Check if device is iPad
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        // Emulate a new delegate method
        //[self dismissPopoverController:self.popoverController withButtonIndex:0 animated:YES];
    } else {
        if (isOSAtLeast(@"8.0"))  {
            [self dismissModalView:self.modalView withButtonIndex:0 animated:YES];
        } else {
            //[self.actionSheet dismissWithClickedButtonIndex:0 animated:YES];
        }
    }
}
- (IBAction)didDismissWithDoneButton:(id)sender {
    
    // Check if device is iPad
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        // Emulate a new delegate method
        //[self dismissPopoverController:self.popoverController withButtonIndex:0 animated:YES];
    } else {
        if (isOSAtLeast(@"8.0"))  {
            NSTimeInterval seconds = [myPicker.date timeIntervalSince1970];
            NSString* jsCallback = [NSString stringWithFormat:@"datePicker._dateSelected(\"%f\");", seconds];
            [super writeJavascript:jsCallback];
            [self dismissModalView:self.modalView withButtonIndex:1 animated:YES];
        } else {
            //[self.actionSheet dismissWithClickedButtonIndex:1 animated:YES];
        }
    }
}
- (void)dismissModalView:(UIView *)modalView withButtonIndex:(NSInteger)buttonIndex animated:(Boolean)animated {
    
    //Hide the view animated and then remove it.
    [UIView animateWithDuration:0.5
                          delay:0.0
                        options: 0
                     animations:^{
                         CGRect viewFrame = self.viewController.view.frame;
                         [self.modalView.subviews[1] setFrame: CGRectOffset(viewFrame, 0, viewFrame.size.height)];
                         [self.modalView.subviews[0] setFrame: CGRectOffset(viewFrame, 0, viewFrame.size.height)];
                         [self.modalView setBackgroundColor:[UIColor clearColor]];
                     }
                     completion:^(BOOL finished) {
                         [self.modalView removeFromSuperview];
                     }];
    
    // Retreive pickerView
    //[self sendResultsFromPickerView:self.pickerView withButtonIndex:buttonIndex];
}
- (BOOL)showForPhone:(NSMutableDictionary *)options {
    /*if(!self.isVisible){
        self.datePickerSheet = [self createActionSheet:options];
        self.isVisible = TRUE;
    }*/
    if (!isOSAtLeast(@"8.0"))  {
        if(!self.isVisible){
            self.datePickerSheet = [self createActionSheet:options];
            self.isVisible = TRUE;
        }
    }else{
        //UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 250, 0, 0)];
        NSDateFormatter *_formatter = [[NSDateFormatter alloc] init];
        [_formatter setLocale:[NSLocale currentLocale]];
        [_formatter setDateStyle:NSDateFormatterNoStyle];
        [_formatter setTimeStyle:NSDateFormatterShortStyle];
        NSString *_dateString = [_formatter stringFromDate:[NSDate date]];
        NSRange amRange = [_dateString rangeOfString:[_formatter AMSymbol]];
        NSRange pmRange = [_dateString rangeOfString:[_formatter PMSymbol]];
        BOOL is24h = (amRange.location == NSNotFound && pmRange.location == NSNotFound);
        if(!is24h){
            formatter = [self createISODateFormatter:@"yyyy-MM-dd'T'hh:mm:ss'Z'" timezone:[NSTimeZone defaultTimeZone]];
        }else{
            formatter = [self createISODateFormatter:@"yyyy-MM-dd'T'HH:mm:ss'Z'" timezone:[NSTimeZone defaultTimeZone]];
        }
        
        NSString *strCurrentDate;
        NSString *strNewDate;
        NSDate *date = [NSDate date];
        NSDateFormatter *df =[[NSDateFormatter alloc]init];
        [df setDateStyle:NSDateFormatterMediumStyle];
        [df setTimeStyle:NSDateFormatterMediumStyle];
        strCurrentDate = [df stringFromDate:date];
        NSLog(@"Current Date and Time: %@",strCurrentDate);
        int hoursToAdd = 1;
        NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
        NSDateComponents *components = [[NSDateComponents alloc] init];
        [components setHour:hoursToAdd];
        NSDate *newDate= [calendar dateByAddingComponents:components toDate:date options:0];
        [df setDateStyle:NSDateFormatterMediumStyle];
        [df setTimeStyle:NSDateFormatterMediumStyle];
        strNewDate = [df stringFromDate:newDate];
        NSLog(@"New Date and Time: %@",strNewDate);
        
        
        
        
        CGRect pickerFrame = CGRectMake(0,250,0,0);
        myPicker = [[UIDatePicker alloc] initWithFrame:pickerFrame];
        [myPicker addTarget:self action:@selector(pickerChanged:)               forControlEvents:UIControlEventValueChanged];
        [myPicker setBackgroundColor:[UIColor clearColor]];
        myPicker.minimumDate = newDate;
        /*//[myPicker release];
         CGRect viewFrame = self.viewController.view.frame;
         [view setFrame: CGRectMake(0, viewFrame.size.height, 320, 260)];
         
         // Create the modal view to display
         self.modalView = [[UIView alloc] initWithFrame:viewFrame];
         [self.modalView setBackgroundColor:[UIColor clearColor]];
         [self.modalView addSubview: view];
         [self.modalView addSubview:myPicker];
         
         // Add the modal view to current controller
         [self.viewController.view addSubview:self.modalView];
         [self.viewController.view bringSubviewToFront:self.modalView];*/
        
        //Present the view animated
        /* [UIView animateWithDuration:0.5
         delay:0.0
         options: 0
         animations:^{
         [self.modalView.subviews[0] setFrame: CGRectOffset(viewFrame, 0, viewFrame.size.height-260)];;
         [self.modalView setBackgroundColor:[UIColor colorWithWhite:0.0 alpha:0.5]];
         }
         completion:nil];*/
        //self.callbackId = command.callbackId;
        //NSDictionary *options = [command.arguments objectAtIndex:0];
        
        // Compiling options with defaults
        NSString *title = [options objectForKey:@"title"] ?: @" ";
        NSString *doneButtonLabel = [options objectForKey:@"doneButtonLabel"] ?: @"Done";
        NSString *cancelButtonLabel = [options objectForKey:@"cancelButtonLabel"] ?: @"Cancel";
        
        
        
        // Initialize the toolbar with Cancel and Done buttons and title
        UIToolbar *toolbar = [[UIToolbar alloc] initWithFrame: CGRectMake(0, 0, self.viewSize.width, 44)];
        toolbar.barStyle = isOSAtLeast(@"7.0") ? UIBarStyleDefault : UIBarStyleBlackTranslucent;
        NSMutableArray *buttons =[[NSMutableArray alloc] init];
        
        // Create Cancel button
        UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc]initWithTitle:cancelButtonLabel style:UIBarButtonItemStylePlain target:self action:@selector(didDismissWithCancelButton:)];
        [buttons addObject:cancelButton];
        
        // Create title label aligned to center and appropriate spacers
        UIBarButtonItem *flexSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
        [buttons addObject:flexSpace];
        UILabel *label =[[UILabel alloc] initWithFrame:CGRectMake(0, 0, 180, 30)];
        [label setTextAlignment:NSTextAlignmentCenter];
        [label setTextColor: isOSAtLeast(@"7.0") ? [UIColor blackColor] : [UIColor whiteColor]];
        [label setFont: [UIFont boldSystemFontOfSize:16]];
        [label setBackgroundColor:[UIColor clearColor]];
        label.text = title;
        UIBarButtonItem *labelButton = [[UIBarButtonItem alloc] initWithCustomView:label];
        [buttons addObject:labelButton];
        [buttons addObject:flexSpace];
        
        // Create Done button
        UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithTitle:doneButtonLabel style:UIBarButtonItemStyleDone target:self action:@selector(didDismissWithDoneButton:)];
        [buttons addObject:doneButton];
        [toolbar setItems:buttons animated:YES];
        
        
        // Initialize the View that should conain the toolbar and picker
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.viewSize.width, 260)];
        if(isOSAtLeast(@"7.0")) {
            [view setBackgroundColor:[UIColor colorWithRed:0.97 green:0.97 blue:0.97 alpha:1.0]];
        }
        [view addSubview: toolbar];
        // [view addSubview:myPicker];
        CGRect viewFrame = self.viewController.view.frame;
        [view setFrame: CGRectMake(0, viewFrame.size.height, self.viewSize.width, 260)];
        
        // Create the modal view to display
        self.modalView = [[UIView alloc] initWithFrame:viewFrame];
        [self.modalView setBackgroundColor:[UIColor clearColor]];
        [self.modalView addSubview: view];
        [self.modalView addSubview: myPicker];
        
        // Add the modal view to current controller
        [self.viewController.view addSubview:self.modalView];
        [self.viewController.view bringSubviewToFront:self.modalView];
        
        //Present the view animated
        [UIView animateWithDuration:0.5
                              delay:0.0
                            options: 0
                         animations:^{
                             //                         [self.modalView.subviews[1]]
                             [self.modalView.subviews[1] setFrame: CGRectOffset(viewFrame, 0, viewFrame.size.height-220)];;
                             [self.modalView.subviews[0] setFrame: CGRectOffset(viewFrame, 0, viewFrame.size.height-260)];;
                             
                             [self.modalView setBackgroundColor:[UIColor colorWithWhite:0.0 alpha:0.5]];
                         }
                         completion:nil];

    }
          return true;
}
- (CGSize) viewSize {
    
    return CGSizeMake(320, 480);
}
- (void)pickerChanged:(id)sender
{
    NSLog(@"value: %@",[sender date]);
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
                                                             delegate:self
                                                    cancelButtonTitle:nil
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
    [cancelButton setTitle:@"Cancelar" forSegmentAtIndex:0];
    [actionSheet addSubview:cancelButton];
    // done button
    UISegmentedControl *doneButton = [self createDoneButton:options];
    [doneButton setTitle:@"Hecho" forSegmentAtIndex:0];
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
NSDateFormatter *formatter;
- (void)updateDatePicker:(NSMutableDictionary *)options {
    NSDateFormatter *_formatter = [[NSDateFormatter alloc] init];
    [_formatter setLocale:[NSLocale currentLocale]];
    [_formatter setDateStyle:NSDateFormatterNoStyle];
    [_formatter setTimeStyle:NSDateFormatterShortStyle];
    NSString *_dateString = [_formatter stringFromDate:[NSDate date]];
    NSRange amRange = [_dateString rangeOfString:[_formatter AMSymbol]];
    NSRange pmRange = [_dateString rangeOfString:[_formatter PMSymbol]];
    BOOL is24h = (amRange.location == NSNotFound && pmRange.location == NSNotFound);
    if(!is24h){
        formatter = [self createISODateFormatter:@"yyyy-MM-dd'T'hh:mm:ss'Z'" timezone:[NSTimeZone defaultTimeZone]];
    }else{
        formatter = [self createISODateFormatter:@"yyyy-MM-dd'T'HH:mm:ss'Z'" timezone:[NSTimeZone defaultTimeZone]];
    }
    
    NSString *mode = [options objectForKey:@"mode"];
    //NSString *dateString = [options objectForKey:@"date"];
    BOOL allowOldDates = NO;
    BOOL allowFutureDates = YES;
    NSString *minDateString = [options objectForKey:@"minDate"];
    NSString *maxDateString = [options objectForKey:@"maxDate"];
    NSString *strCurrentDate;
    NSString *strNewDate;
    NSDate *date = [NSDate date];
    NSDateFormatter *df =[[NSDateFormatter alloc]init];
    [df setDateStyle:NSDateFormatterMediumStyle];
    [df setTimeStyle:NSDateFormatterMediumStyle];
    strCurrentDate = [df stringFromDate:date];
    NSLog(@"Current Date and Time: %@",strCurrentDate);
    int hoursToAdd = 1;
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *components = [[NSDateComponents alloc] init];
    [components setHour:hoursToAdd];
    NSDate *newDate= [calendar dateByAddingComponents:components toDate:date options:0];
    [df setDateStyle:NSDateFormatterMediumStyle];
    [df setTimeStyle:NSDateFormatterMediumStyle];
    strNewDate = [df stringFromDate:newDate];
    NSLog(@"New Date and Time: %@",strNewDate);
    if ([[options objectForKey:@"allowOldDates"] intValue] == 1) {
        allowOldDates = YES;
    }
    
    if ( !allowOldDates) {
        self.datePicker.minimumDate = newDate;
    }
    
    if(minDateString){
        self.datePicker.minimumDate = newDate;
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
    
    self.datePicker.date = newDate;
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
    //button.segmentedControlStyle = UISegmentedControlStyleBar;
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
    //button.segmentedControlStyle = UISegmentedControlStyleBar;
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
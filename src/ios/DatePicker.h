/*
 Phonegap DatePicker Plugin for using Cordova 3 and iOS 7
 https://github.com/sectore/phonegap3-ios-datepicker-plugin
 
 Based on a previous plugin version by Greg Allen and Sam de Freyssinet.
 
 Rewrite by Jens Krause (www.websector.de)
 
 MIT Licensed
*/

#import <Foundation/Foundation.h>
#import <Cordova/CDV.h>

@interface DatePicker : CDVPlugin <UIPopoverControllerDelegate> {
    
}

- (void)show:(CDVInvokedUrlCommand*)command;

@end
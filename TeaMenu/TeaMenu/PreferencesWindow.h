//
//  PreferencesWindow.h
//  TeaMenu
//
//  Created by Jan on 22.09.16.
//
//

#import <Cocoa/Cocoa.h>

#define NOTIFICATION_DISPLAY_PREF_KEY @"NotificationDisplay"

@interface PreferencesWindow : NSWindowController

@property () NSUserDefaults *defaults;

@property (weak) IBOutlet NSButton *hapticCheckbox;

- (IBAction)changeNotificationDisplayPreference:(NSButton *)sender;

@end

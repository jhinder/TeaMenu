//
//  PreferencesWindow.m
//  TeaMenu
//
//  Created by Jan on 22.09.16.
//
//

#import "PreferencesWindow.h"

@interface PreferencesWindow ()

@end

@implementation PreferencesWindow

@synthesize defaults;

- (instancetype) init
{
    if ((self = [super init])) {
        defaults = [NSUserDefaults standardUserDefaults];
    }
    return self;
}

- (void) windowDidLoad
{
    [super windowDidLoad];
    // Set correct Dingsda mit den Radiuobuttons
}

- (IBAction)changeNotificationDisplayPreference:(NSButton * __nonnull)sender
{
    NSInteger selectedTag = [sender tag];
    [defaults setInteger:selectedTag forKey:NOTIFICATION_DISPLAY_PREF_KEY];
    [defaults synchronize];
}

@end

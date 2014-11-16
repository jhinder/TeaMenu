//
//  AppDelegate.m
//  TeaMenu
//
//  Created by Jan on 13.11.14.
//  Copyright (c) 2014 dfragment.net. All rights reserved.
//

#import "AppDelegate.h"

@implementation AppDelegate

@synthesize appMenu = _appMenu;
@synthesize item = _item;
@synthesize userTeaArray = userTeas;

/* Quick translation macro. */
#ifndef T
    #define T(x) NSLocalizedString(@x, nil)
#else
    #warning T defined twice! May lead to problems.
#endif

/* Called when the app launches, and sets up the menu. */
- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    [self preparePreferences];
    userTeas = [[[NSUserDefaults standardUserDefaults] arrayForKey:@"Teas"] mutableCopy];
    
    NSStatusBar *bar = [NSStatusBar systemStatusBar];

    _item = [[bar statusItemWithLength:NSVariableStatusItemLength] retain];
    [self changeIcons:false];
    _item.highlightMode = true;
    _item.menu = _appMenu;

}

/* Copies the default preferences into the user domain if necessary. */
- (void) preparePreferences
{
    NSUserDefaults *localPreferences = [NSUserDefaults standardUserDefaults];
    NSURL *defaultPrefs = [[NSBundle mainBundle] URLForResource:@"DefaultTeas" withExtension:@"plist"];
    NSDictionary *teaDicts = [NSDictionary dictionaryWithContentsOfURL:defaultPrefs];
    [localPreferences registerDefaults:teaDicts];
}

/* Should be called when the menu icons should be changed.
 * steaming: indicates if the cup icon should display steam.
 */
- (void) changeIcons:(bool)steaming
{
    if (steaming) {
        _item.image = [NSImage imageNamed:@"menu-steamblack"];
        _item.alternateImage = [NSImage imageNamed:@"menu-steamwhite"];
    } else {
        _item.image = [NSImage imageNamed:@"menu-black"];
        _item.alternateImage = [NSImage imageNamed:@"menu-white"];        
    }
}

/* Action to start a pre-defined timer.
 * Note: if you want to add other pre-defined timers, set their tag
 * property to the seconds the timer should run for.
 */
- (IBAction)startTimer:(id)sender
{
    NSInteger seconds = [sender tag];
    [self actualTimerStart:seconds];
}

/* Actually starts the timer. */
- (void) actualTimerStart: (NSInteger) seconds
{
#ifdef DEBUG
    seconds = 1;
#endif
    [self changeIcons:true];
    [self performSelector:@selector(timerUp) withObject:nil afterDelay:seconds];
}

/* Called once a timer expires. */
- (void) timerUp
{
    [self changeIcons:false];
    NSAlert *alert = [[NSAlert alloc] init];
    [alert setMessageText:T("TEA_READY")];
    [alert setIcon:[NSImage imageNamed:@"Teaicon_Done.png"]];
    [alert addButtonWithTitle:@"OK"];
    [alert runModal];
}

/* Displays a dialogue to users, from which they can start their own timers. */
- (IBAction)showCustomTimer:(id)sender
{
    NSTextField *accessoryField = [[NSTextField alloc] initWithFrame:NSMakeRect(0, 0, 64, 24)];
    accessoryField.integerValue = 3;
    NSNumberFormatter *numformat = [[NSNumberFormatter alloc] init];
    [accessoryField setFormatter:numformat];
    
    NSAlert *alert = [[NSAlert alloc] init];
    [alert setMessageText:T("CUSTOM_TIMER")];
    [alert addButtonWithTitle:T("START_TIMER")];
    [alert addButtonWithTitle:T("CANCEL")];
    [alert setInformativeText:T("CUSTOM_TIMER_INFO")];
    [alert setAccessoryView:accessoryField];
    NSInteger retValue = [alert runModal];
    if (retValue != NSAlertFirstButtonReturn)
        return;
    
    NSInteger seconds = accessoryField.integerValue * 60;
    [self actualTimerStart:seconds];

}

/* Interface action for app exit. Saves the settings, then terminates. */
- (IBAction)terminate:(id)sender
{
    NSUserDefaults *localSettings = [NSUserDefaults standardUserDefaults];
    [localSettings setObject:userTeas forKey:@"Teas"];
    [localSettings synchronize];
    [NSApp terminate:0];
}

/* Called at destruction. */
- (void)dealloc
{
    [super dealloc];
}

@end

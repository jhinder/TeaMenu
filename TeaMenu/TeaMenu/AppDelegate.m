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
    
    // Add all user teas to the menu
    for (NSUInteger i = 0; i < userTeas.count; i++) {
        NSDictionary *currentTeaDict = [userTeas objectAtIndex:i];
        NSInteger teaTime = [[currentTeaDict objectForKey:@"Time"] integerValue];
        NSString *menuItemTitle = [NSString stringWithFormat:@"%@ (%d %@)",
                                            [currentTeaDict objectForKey:@"Tea Type"],
                                            teaTime,
                                            T("MINUTES.SHORT")];
        NSMenuItem *item = [[[NSMenuItem alloc] initWithTitle:menuItemTitle 
                                               action:@selector(startTimer:)
                                               keyEquivalent:@""] autorelease];
        [item setTag:(teaTime * 60)];
        [_appMenu insertItem:item atIndex:i];
    }
    
    _item.menu = _appMenu;
    
}

/* Copies the default preferences into the user domain if necessary. */
- (void) preparePreferences
{
    NSUserDefaults *localPreferences = [NSUserDefaults standardUserDefaults];
    
    // Detecting user's preferred language or default to en
    NSArray *language = [NSLocale preferredLanguages];
    NSString *userLocale = (language.count == 0) ? @"en" : [language objectAtIndex:0];
    
    NSURL *defaultPrefs = [[NSBundle mainBundle] URLForResource:@"DefaultTeas"
                                                 withExtension:@"plist"
                                                 subdirectory:[userLocale stringByAppendingPathExtension:@"lproj"]];
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
    [alert release];
}

/* Displays a dialogue to users, from which they can start their own timers. */
- (IBAction)showCustomTimer:(id)sender
{
    NSTextField *accessoryField = [[[NSTextField alloc] initWithFrame:NSMakeRect(0, 0, 64, 24)] autorelease];
    accessoryField.integerValue = 3;
    NSNumberFormatter *numformat = [[[NSNumberFormatter alloc] init] autorelease];
    [accessoryField setFormatter:numformat];
    
    NSAlert *alert = [[[NSAlert alloc] init] autorelease];
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

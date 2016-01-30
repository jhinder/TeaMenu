//
//  AppDelegate.m
//  TeaMenu
//
//  Created by Jan on 13.11.14.
//  Copyright (c) 2014 dfragment.net. All rights reserved.
//

#import "AppDelegate.h"

#import "TeaDatabase.h"
#import "TeaEditor.h"
#import "CustomTeaItemViewController.h"
#import "TeaManager.h"

#define CAN_USE_NCENTER NSAppKitVersionNumber >= NSAppKitVersionNumber10_8

@implementation AppDelegate

@synthesize appMenu = _appMenu;
@synthesize item = _item;
@synthesize stopTeaItem = stopTimerItem;
@synthesize database;
@synthesize mug, mugSteaming;
@synthesize editor;
@synthesize customTeaItem;
@synthesize teaManager;

/* Quick translation macro. */
#ifndef T
    #define T(x) NSLocalizedString(@x, nil)
#else
    #warning T defined twice! May lead to problems.
#endif

// Macro for registering for notifications
#define RegisterForNotification(notifName, sel) \
    [[NSNotificationCenter defaultCenter] addObserver:self \
        selector:@selector(sel) \
        name:notifName \
        object:nil]

NSInteger currentTeaCount = 0;

/* Called when the app launches, and sets up the menu. */
- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
	database = [[TeaDatabase alloc] init];
    if (database == nil) {
        // Could not init the database, for some reason. (How to handle?)
    }
    
    teaManager = [[TeaManager alloc] init];
	
	/* Templating has two major benefits:
	 * a) we get white versions of the icons when needed,
	 * b) it works natively with the dark mode of 10.10+.
	 */
	mug = [NSImage imageNamed:@"menu-black"];
	[mug setTemplate:YES];
	mugSteaming = [NSImage imageNamed:@"menu-steamblack"];
	[mugSteaming setTemplate:YES];
    
    RegisterForNotification(START_TEA_NOTIFICATION, startTeaNotification:);
    RegisterForNotification(STOP_TEA_NOTIFICATION, stopTeaNotification:);
    RegisterForNotification(RELOAD_TEAS, reloadTeaMenu:);
	
	// Database init/loading
	if ([database countTeas] == 0)
		[self copyDefaultTeas];
	
	// Initialize menu bar/status item
    _item = [[NSStatusBar systemStatusBar] statusItemWithLength:NSVariableStatusItemLength];
    [self changeIcons:false];
    _item.highlightMode = true;
    
    // Add all user teas to the menu
    [self reloadTeaMenu:nil];
	
	// Load and insert the custom slider view
    customTeaItem = [[CustomTeaItemViewController alloc] initWithNibName:@"CustomTeaMenuItem"
                                                                  bundle:[NSBundle mainBundle]];
	NSView *theView = [customTeaItem view];
	NSMenuItem *customSliderItem = [[NSMenuItem alloc] init];
	[customSliderItem setView:theView];
	[_appMenu insertItem:customSliderItem atIndex:currentTeaCount];
    // used to be (index+1); using (index) puts the custom slider just above the "Stop timer" field, which is where it should go.
	
    _item.menu = _appMenu;
    
}

/* Copy the Default Teas plist into the database */
- (void) copyDefaultTeas
{
    // Detecting user's preferred language or default to en
    NSArray *language = [NSLocale preferredLanguages];
    NSString *userLocale = (language.count == 0) ? @"en" : language[0];
    NSArray *supportedLanguages = @[@"en", @"de", @"it",
                                    @"fr", @"es", @"nl",
                                    @"sv", @"da", @"pt"];
	if (![supportedLanguages containsObject:userLocale])
		userLocale = @"en";
    
    NSURL *defaultPrefs = [[NSBundle mainBundle] URLForResource:@"DefaultTeas"
                                                 withExtension:@"plist"];
    NSDictionary *teaDicts = [NSDictionary dictionaryWithContentsOfURL:defaultPrefs];
    NSDictionary *langDict = teaDicts[userLocale];
	
	for (NSDictionary *subTea in langDict[@"Teas"]) {
		NSString *name = subTea[@"TeaType"];
		int time = [subTea[@"Time"] intValue];
		[database insertTeaWithName:name andTime:time];
	}
}

/**
 Changes the icon for the menu bar icon.
 @param steaming Determines if the icon should show the steaming mug.
 */
- (void) changeIcons:(bool)steaming
{
	_item.image = (steaming ? mugSteaming : mug);
}

/* Action to start a pre-defined timer.
 * Note: if you want to add other pre-defined timers, set their tag
 * property to the seconds the timer should run for.
 */
- (IBAction)startTimer:(id)sender
{
    NSNumber *startObj = @([sender tag]);
    [[NSNotificationCenter defaultCenter] postNotificationName:START_TEA_NOTIFICATION
                                                        object:startObj];
}

/* Interface action to stop the timer. */
- (IBAction) stopTimer:(id)sender
{
	NSNumber *stopObj = @YES; // true = user cancelled
    [[NSNotificationCenter defaultCenter] postNotificationName:STOP_TEA_NOTIFICATION
                                                        object:stopObj];
}

- (void) startTeaNotification:(NSNotification *)notification
{
    // Set user interface to "tea brewing"
    [self changeIcons:true];
	[stopTimerItem setEnabled:YES];
    [_appMenu cancelTracking]; // closes the menu on click, even for CustomTeaMI
}

/**
 * Shows the tea notification.
 * @param showInCenter Shows the notification in the Notification Center if possible.
 */
- (void) showTeaNotification:(bool)showInCenter
{
    if (showInCenter && !(CAN_USE_NCENTER))
        showInCenter = false; // Can't use Notification Center before 10.8
    
    if (showInCenter) {
        NSUserNotification *notification = [[NSUserNotification alloc] init];
        [notification setTitle:T("TEA_READY")];
        [notification setDeliveryDate:[NSDate date]]; // i.e. now
        [[NSUserNotificationCenter defaultUserNotificationCenter] scheduleNotification:notification];
        // TODO how to find out if it was actually delivered? Full screen hides the notifications

    } else {
        NSAlert *alert = [[NSAlert alloc] init];
        [alert setMessageText:T("TEA_READY")];
        [alert setIcon:[NSImage imageNamed:@"TeaIcon_Done"]];
        [alert addButtonWithTitle:@"OK"];
        [alert runModal];
    }
}

- (void) stopTeaNotification:(NSNotification *)notification
{
    // Set user interface to "no tea brewing"
    [self changeIcons:NO];
	[stopTimerItem setEnabled:NO];
    if (notification.object != nil && !((NSNumber *)notification.object).boolValue) {
        [self showTeaNotification:true];
        // TODO make this dynamic, based on OS and user settings
        // For now it defaults to "notification" for 10.8+, and "alert" for all others
    }
}

/* Shows the tea database editor */
- (IBAction)openTeaEditor:(id)sender
{
    if (database == nil)
        return;
	if (editor == nil)
		editor = [[TeaEditor alloc] initWithWindowNibName:@"TeaEditorWindow"];
	[editor showWindow:self];
}

- (void) reloadTeaMenu:(NSNotification *)_
{
    // Phase 1: remove all teas
    for (NSMenuItem *item in _appMenu.itemArray) {
        if (item.tag != 0)
            [_appMenu removeItem:item];
    }
    
    // Phase 2: insert all teas.
    NSArray *dbTeas = [database queryTeas];
    int index = 0;
    for (TeaObject *tea in dbTeas) {
        NSInteger teaTime = tea.teaDuration;
        NSString *menuItemTitle = [NSString stringWithFormat:@"%@ (%ld %@)",
                                   tea.teaName,
                                   (long)teaTime,
                                   T("MINUTES.SHORT")];
        NSMenuItem *item = [[NSMenuItem alloc] initWithTitle:menuItemTitle
                                                      action:@selector(startTimer:)
                                               keyEquivalent:@""];
        [item setTag:(teaTime * 60)];
        [_appMenu insertItem:item atIndex:(index++)];
    }
    currentTeaCount = dbTeas.count;
}

/* Interface action for app exit. Saves the settings, then terminates. */
- (IBAction)terminate:(id)sender
{
    // Cleanup
    if (CAN_USE_NCENTER)
        [[NSUserNotificationCenter defaultUserNotificationCenter] removeAllDeliveredNotifications];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    // Terminate the app
    [NSApp terminate:0];
}

#undef T

@end

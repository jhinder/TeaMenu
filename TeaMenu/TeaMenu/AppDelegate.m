//
//  AppDelegate.m
//  TeaMenu
//
//  Created by Jan on 13.11.14.
//  Copyright (c) 2014 dfragment.net. All rights reserved.
//

#import "AppDelegate.h"

#import "TeaDatabase.h"
#import "TeaObject.h"
#import "TeaEditor.h"
#import "CustomTeaItemViewController.h"
#import "TeaManager.h"

#define NOTIFICATION_DISPLAY_PREF_KEY @"NotificationDisplay"

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
	
    // Load preferences for notification display
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    NSInteger displayPreference = [prefs integerForKey:NOTIFICATION_DISPLAY_PREF_KEY];
    if (displayPreference == 0) { // 0 = not set
        displayPreference = 2;
        [prefs setInteger:displayPreference forKey:NOTIFICATION_DISPLAY_PREF_KEY];
        [prefs synchronize];
    }
    [(displayPreference == 1 ? _displayOptionAlertItem : _displayOptionNCItem) setState:NSOnState];
    
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
    if (showInCenter) {
        // Clear all previous notifications so we don't clutter up the NC
        [[NSUserNotificationCenter defaultUserNotificationCenter] removeAllDeliveredNotifications];
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
        BOOL showInNC = ([[NSUserDefaults standardUserDefaults] integerForKey:NOTIFICATION_DISPLAY_PREF_KEY]) == 2;
        [self showTeaNotification:showInNC];
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
        NSInteger teaTime = tea.time.integerValue;
        NSString *menuItemTitle = [NSString stringWithFormat:@"%@ (%ld %@)",
                                   tea.name,
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

- (IBAction)changeNotificationDisplayPrefs:(id)sender
{
    NSInteger tag = ((NSMenuItem *)sender).tag;
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setInteger:tag forKey:NOTIFICATION_DISPLAY_PREF_KEY];
    [_displayOptionAlertItem setState:(tag == 1) ? NSOnState : NSOffState];
    [_displayOptionNCItem    setState:(tag == 2) ? NSOnState : NSOffState];
    [defaults synchronize];
}

/* Interface action for app exit. Saves the settings, then terminates. */
- (IBAction)terminate:(id)sender
{
    // Cleanup
    [[NSUserNotificationCenter defaultUserNotificationCenter] removeAllDeliveredNotifications];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    // Terminate the app
    [NSApp terminate:0];
}

#undef T

#pragma mark - Core Data stack

@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize managedObjectContext = _managedObjectContext;

- (NSURL *)applicationDocumentsDirectory {
    // The directory the application uses to store the Core Data store file. This code uses a directory named "net.dfragment.TeaMenu" in the user's Application Support directory.
    NSURL *appSupportURL = [[[NSFileManager defaultManager] URLsForDirectory:NSApplicationSupportDirectory inDomains:NSUserDomainMask] lastObject];
    return [appSupportURL URLByAppendingPathComponent:@"net.dfragment.TeaMenu"];
}

- (NSManagedObjectModel *)managedObjectModel {
    // The managed object model for the application. It is a fatal error for the application not to be able to find and load its model.
    if (_managedObjectModel) {
        return _managedObjectModel;
    }
    
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"TeaMenu" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    // The persistent store coordinator for the application. This implementation creates and returns a coordinator, having added the store for the application to it. (The directory for the store is created, if necessary.)
    if (_persistentStoreCoordinator) {
        return _persistentStoreCoordinator;
    }
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSURL *applicationDocumentsDirectory = [self applicationDocumentsDirectory];
    BOOL shouldFail = NO;
    NSError *error = nil;
    NSString *failureReason = @"There was an error creating or loading the application's saved data.";
    
    // Make sure the application files directory is there
    NSDictionary *properties = [applicationDocumentsDirectory resourceValuesForKeys:@[NSURLIsDirectoryKey] error:&error];
    if (properties) {
        if (![properties[NSURLIsDirectoryKey] boolValue]) {
            failureReason = [NSString stringWithFormat:@"Expected a folder to store application data, found a file (%@).", [applicationDocumentsDirectory path]];
            shouldFail = YES;
        }
    } else if ([error code] == NSFileReadNoSuchFileError) {
        error = nil;
        [fileManager createDirectoryAtPath:[applicationDocumentsDirectory path] withIntermediateDirectories:YES attributes:nil error:&error];
    }
    
    if (!shouldFail && !error) {
        NSPersistentStoreCoordinator *coordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
        NSURL *url = [applicationDocumentsDirectory URLByAppendingPathComponent:@"TeaMenu.storedata"];
        if (![coordinator addPersistentStoreWithType:NSXMLStoreType configuration:nil URL:url options:nil error:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            
            /*
             Typical reasons for an error here include:
             * The persistent store is not accessible, due to permissions or data protection when the device is locked.
             * The device is out of space.
             * The store could not be migrated to the current model version.
             Check the error message to determine what the actual problem was.
             */
            coordinator = nil;
        }
        _persistentStoreCoordinator = coordinator;
    }
    
    if (shouldFail || error) {
        // Report any error we got.
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        dict[NSLocalizedDescriptionKey] = @"Failed to initialize the application's saved data";
        dict[NSLocalizedFailureReasonErrorKey] = failureReason;
        if (error) {
            dict[NSUnderlyingErrorKey] = error;
        }
        error = [NSError errorWithDomain:@"YOUR_ERROR_DOMAIN" code:9999 userInfo:dict];
        [[NSApplication sharedApplication] presentError:error];
        NSLog(@"Unresolved error %@, %@", error, error.userInfo);
        abort();
    }
    return _persistentStoreCoordinator;
}

- (NSManagedObjectContext *)managedObjectContext {
    // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.)
    if (_managedObjectContext) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (!coordinator) {
        return nil;
    }
    _managedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
    [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    
    return _managedObjectContext;
}

#pragma mark - Core Data Saving and Undo support

- (IBAction)saveAction:(id)sender {
    // Performs the save action for the application, which is to send the save: message to the application's managed object context. Any encountered errors are presented to the user.
    NSManagedObjectContext *context = self.managedObjectContext;
    
    if (![context commitEditing]) {
        NSLog(@"%@:%@ unable to commit editing before saving", [self class], NSStringFromSelector(_cmd));
    }
    
    NSError *error = nil;
    if (context.hasChanges && ![context save:&error]) {
        [[NSApplication sharedApplication] presentError:error];
    }
}

- (NSUndoManager *)windowWillReturnUndoManager:(NSWindow *)window {
    // Returns the NSUndoManager for the application. In this case, the manager returned is that of the managed object context for the application.
    return [[self managedObjectContext] undoManager];
}

- (NSApplicationTerminateReply)applicationShouldTerminate:(NSApplication *)sender {
    // Save changes in the application's managed object context before the application terminates.
    NSManagedObjectContext *context = _managedObjectContext;
    
    if (!context) {
        return NSTerminateNow;
    }
    
    if (![context commitEditing]) {
        NSLog(@"%@:%@ unable to commit editing to terminate", [self class], NSStringFromSelector(_cmd));
        return NSTerminateCancel;
    }
    
    if (!context.hasChanges) {
        return NSTerminateNow;
    }
    
    NSError *error = nil;
    if (![context save:&error]) {
        
        // Customize this code block to include application-specific recovery steps.
        BOOL result = [sender presentError:error];
        if (result) {
            return NSTerminateCancel;
        }
        
        NSString *question = NSLocalizedString(@"Could not save changes while quitting. Quit anyway?", @"Quit without saves error question message");
        NSString *info = NSLocalizedString(@"Quitting now will lose any changes you have made since the last successful save", @"Quit without saves error question info");
        NSString *quitButton = NSLocalizedString(@"Quit anyway", @"Quit anyway button title");
        NSString *cancelButton = NSLocalizedString(@"Cancel", @"Cancel button title");
        NSAlert *alert = [[NSAlert alloc] init];
        [alert setMessageText:question];
        [alert setInformativeText:info];
        [alert addButtonWithTitle:quitButton];
        [alert addButtonWithTitle:cancelButton];
        
        NSInteger answer = [alert runModal];
        
        if (answer == NSAlertSecondButtonReturn) {
            return NSTerminateCancel;
        }
    }
    
    return NSTerminateNow;
}

@end

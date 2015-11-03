//
//  AppDelegate.m
//  TeaMenu
//
//  Created by Jan on 13.11.14.
//  Copyright (c) 2014 dfragment.net. All rights reserved.
//

#import "AppDelegate.h"
#import "AppDelegate+Extensions.h"

@implementation AppDelegate

@synthesize appMenu = _appMenu;
@synthesize item = _item;
@synthesize stopTeaItem = stopTimerItem;
@synthesize database;
@synthesize mug;
@synthesize mugSteaming;
@synthesize editor;
@synthesize customTeaItem;

bool teaBrewing;

/* Quick translation macro. */
#ifndef T
    #define T(x) NSLocalizedString(@x, nil)
#else
    #warning T defined twice! May lead to problems.
#endif

/* Called when the app launches, and sets up the menu. */
- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
	database = [[TeaDatabase alloc] init];
	
	/* Templating has two major benefits:
	 * a) we get white versions of the icons when needed,
	 * b) it works natively with Yosemite's dark mode.
	 */
	mug = [NSImage imageNamed:@"menu-black"];
	[mug setTemplate:YES];
	mugSteaming = [NSImage imageNamed:@"menu-steamblack"];
	[mugSteaming setTemplate:YES];
	
	teaBrewing = NO;
	
	// Database init/loading
	if ([database countTeas] == 0)
		[self copyDefaultTeas];
	NSArray *dbTeas = [database queryTeas];
	
	// Initialize menu bar/status item
    _item = [[[NSStatusBar systemStatusBar] statusItemWithLength:NSVariableStatusItemLength] retain];
    [self changeIcons:false];
    _item.highlightMode = true;
    
	// Add all user teas to the menu
	int index = 0;
	for (TeaObject *tea in dbTeas) {
		NSInteger teaTime = tea.teaDuration;
        NSString *menuItemTitle = [NSString stringWithFormat:@"%@ (%d %@)",
								   tea.teaName,
								   teaTime,
								   T("MINUTES.SHORT")];
        NSMenuItem *item = [[[NSMenuItem alloc] initWithTitle:menuItemTitle 
													   action:@selector(startTimer:)
												keyEquivalent:@""] autorelease];
        [item setTag:(teaTime * 60)];
        [_appMenu insertItem:item atIndex:(index++)];
	}
	
	// Load and insert the custom slider view
    customTeaItem = [[CustomTeaItemViewController alloc] initWithNibName:@"CustomTeaMenuItem" bundle:[NSBundle mainBundle]];
	NSView *theView = [customTeaItem view];
	NSMenuItem *customSliderItem = [[[NSMenuItem alloc] init] autorelease];
	[customSliderItem setView:theView];
	[_appMenu insertItem:customSliderItem atIndex:(index)];
    // used to be (index+1); using (index) puts the custom slider just above the "Stop timer" field, which is where it should go.
	
    _item.menu = _appMenu;
    
}

/* Copy the Default Teas plist into the database */
- (void) copyDefaultTeas
{
    // Detecting user's preferred language or default to en
    NSArray *language = [NSLocale preferredLanguages];
    NSString *userLocale = (language.count == 0) ? @"en" : [language objectAtIndex:0];
	NSArray *supportedLanguages = [NSArray arrayWithObjects:@"en", @"de", @"it",
															@"fr", @"es", @"nl", 
															@"sv", @"da", @"pt",
															nil];
	if (![supportedLanguages containsObject:userLocale])
		userLocale = @"en";
    
    NSURL *defaultPrefs = [[NSBundle mainBundle] URLForResource:@"DefaultTeas"
                                                 withExtension:@"plist"];
    NSDictionary *teaDicts = [NSDictionary dictionaryWithContentsOfURL:defaultPrefs];
	NSDictionary *langDict = [teaDicts objectForKey:userLocale];
	
	for (NSDictionary *subTea in [langDict objectForKey:@"Teas"]) {
		NSString *name = [subTea objectForKey:@"Tea Type"];
		NSInteger time = [[subTea objectForKey:@"Time"] integerValue];
		[database insertTeaWithName:name andTime:(int)time];
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
    NSInteger seconds = [sender tag];
    [self actualTimerStart:seconds];
}

/* Actually starts the timer. */
- (void) actualTimerStart: (NSInteger) seconds
{
#ifdef DEBUG
    seconds = 5;
#endif
	teaBrewing = TRUE;
    [self changeIcons:true];
	[stopTimerItem setEnabled:YES];
    [self performSelector:@selector(timerUp) withObject:nil afterDelay:seconds];
}

/* Called once a timer expires. */
- (void) timerUp
{
	teaBrewing = NO;
    [self changeIcons:false];
	[stopTimerItem setEnabled:NO];
	
    NSAlert *alert = [[NSAlert alloc] init];
    [alert setMessageText:T("TEA_READY")];
    [alert setIcon:[NSImage imageNamed:@"TeaIcon_Done"]];
    [alert addButtonWithTitle:@"OK"];
    [alert runModal];
    [alert release];
}

/* Interface action to stop the timer. */
- (IBAction) stopTimer:(id)sender
{
	[self haltTimer];
}

/* Stops the queued timer. */
- (void) haltTimer
{
	if (!teaBrewing)
		return;
	// Cancels all to-be-performed selectors -- which is our tea in this case.
	[NSObject cancelPreviousPerformRequestsWithTarget:self];
	[self changeIcons:NO];
	[stopTimerItem setEnabled:NO];
	teaBrewing = NO;
}

/* Shows the tea database editor */
- (IBAction)openTeaEditor:(id)sender
{
	if (editor == nil)
		editor = [[TeaEditor alloc] initWithWindowNibName:@"TeaEditorWindow"];
	[editor showWindow:self];
}

/* Interface action for app exit. Saves the settings, then terminates. */
- (IBAction)terminate:(id)sender
{
    [database dealloc];
    [NSApp terminate:0];
}

/* Called at destruction. */
- (void)dealloc
{
    [super dealloc];
}

@end

//
//  AppDelegate.h
//  TeaMenu
//
//  Created by Jan on 13.11.14.
//  Copyright (c) 2014 dfragment.net. All rights reserved.
//

#import <AppKit/AppKit.h>
#import <Foundation/Foundation.h>

@interface AppDelegate : NSObject <NSApplicationDelegate>

/* All ivars and properties are found in AppDelegate+Extensions!
 * See that file for the explanation.
 */

- (IBAction)startTimer:(id)sender;
- (IBAction)stopTimer:(id)sender;
- (IBAction)terminate:(id)sender;
- (IBAction)openTeaEditor:(id)sender;

- (void) actualTimerStart: (NSInteger) seconds;
- (void) haltTimer;
- (void) changeIcons:(bool)steaming;
- (void) copyDefaultTeas;
- (void) timerUp;

@end

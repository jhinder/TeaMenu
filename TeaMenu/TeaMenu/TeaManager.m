//
//  TeaManager.m
//  TeaMenu
//
//  Created by Jan on 05.11.15.
//  Copyright (c) 2015 dfragment.net. All rights reserved.
//

#import "TeaManager.h"

@implementation TeaManager

@synthesize teaBrewing;

- (instancetype) init
{
    self = [super init];
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(startTeaNotification:)
                                                     name:START_TEA_NOTIFICATION
                                                   object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(stopTeaNotification:)
                                                     name:STOP_TEA_NOTIFICATION
                                                   object:nil];
    }
    return self;
}

- (void) startTeaNotification:(NSNotification *)notification
{
    // Starting a tea was requested
    if (teaBrewing)
        return;
    if (notification.object != nil) {
        /* Conditional compilation: if 'seconds' is assigned at initialisation,
         * it might get overwritten right after, which is something the static
         * analysis 
         */
        NSInteger seconds = ((NSNumber *)notification.object).integerValue;
#ifdef DEBUG
        seconds = 5;
#endif
        
        [self performSelector:@selector(timerUp) withObject:nil afterDelay:seconds];
        teaBrewing = true;
    }
}

- (void) stopTeaNotification:(NSNotification *)notification
{
    // Cancellation was requested
    if (!teaBrewing)
        return;
    if (notification.object != nil) {
        BOOL cancelled = ((NSNumber *)notification.object).boolValue;
        if (cancelled) {
            // User wants to cancel
            [NSObject cancelPreviousPerformRequestsWithTarget:self];
        }
        teaBrewing = NO;
    }

}

/* Called once a timer expires. */
- (void) timerUp
{
    [[NSNotificationCenter defaultCenter] postNotificationName:STOP_TEA_NOTIFICATION
                                                        object:@NO];
}

- (void) dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end

//
//  TeaTimerNotification.h
//  TeaMenu
//
//  Created by Jan on 05.11.15.
//  Copyright (c) 2015 dfragment.net. All rights reserved.
//

#import <Foundation/Foundation.h>

#ifndef START_TEA_NOTIFICATION
#define START_TEA_NOTIFICATION @"StartTea"
#endif

#ifndef STOP_TEA_NOTIFICATION
#define STOP_TEA_NOTIFICATION @"StopTea"
#endif

@protocol TeaTimerNotification <NSObject>

/* Notification for when a tea timer has started */
- (void) startTeaNotification: (NSNotification *) notification;

/* Notification for when the tea timer has stopped */
- (void) stopTeaNotification: (NSNotification *) notification;

@end

//
//  TeaManager.h
//  TeaMenu
//
//  Created by Jan on 05.11.15.
//  Copyright (c) 2015 dfragment.net. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TeaTimerNotification.h"

@interface TeaManager : NSObject <TeaTimerNotification>

@property (assign) BOOL teaBrewing;

- (void) timerUp;

@end

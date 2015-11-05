//
//  CustomTeaItemViewController.h
//  TeaMenu
//
//  Created by Jan on 03.11.15.
//  Copyright (c) 2015 dfragment.net. All rights reserved.
//

#import <AppKit/AppKit.h>
#import "CustomTeaMenuItem.h"
#import "TeaTimerNotification.h"

@interface CustomTeaItemViewController : NSViewController <TeaTimerNotification> {
}

@property (retain) CustomTeaTimeModel *timerModel;
@property (retain) CustomTeaMenuItem *timerView;

- (IBAction)startTimer:(id)sender;

@end

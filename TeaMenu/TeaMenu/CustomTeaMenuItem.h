//
//  CustomTeaMenuItem.h
//  TeaMenu
//
//  Created by Jan on 03.11.15.
//  Copyright (c) 2015 dfragment.net. All rights reserved.
//

#import <AppKit/AppKit.h>

@interface CustomTeaTimeModel : NSObject
@property (nonatomic, assign) NSInteger minutes;
@end

@interface CustomTeaMenuItem : NSView {
    CustomTeaTimeModel *model;
}

@property (nonatomic, assign) CustomTeaTimeModel *model;

@end

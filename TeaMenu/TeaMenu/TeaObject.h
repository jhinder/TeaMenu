//
//  TeaDataModel.h
//  TeaMenu
//
//  Created by Jan on 16.09.16.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface TeaObject : NSManagedObject

@property (nonatomic, retain) NSString *name;
@property (nonatomic, retain) NSNumber *time;

@end

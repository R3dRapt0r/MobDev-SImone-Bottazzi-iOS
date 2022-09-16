//
//  Reminder.h
//  progetto_ios
//
//  Created by Simone Bottazzi on 10/07/22.
//

#import <Foundation/Foundation.h>
#import "MapKit/MapKit.h"

@interface Reminder : NSObject

@property NSString* title;
@property NSString* subtitle;
@property double longitude;
@property double latitude;
@property NSDate* date;
@property bool active;
@property bool completed;
@property CLCircularRegion* region;

- (instancetype) initWithParams: (NSString *)title : (NSString *)subtitle : (double) longitude : (double) latitude : (NSDate *) date : (bool) active;

@end

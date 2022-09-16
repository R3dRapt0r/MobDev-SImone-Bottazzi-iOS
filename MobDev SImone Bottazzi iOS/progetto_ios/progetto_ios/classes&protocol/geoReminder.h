//
//  geoReminder.h
//  progetto_ios
//
//  Created by Simone Bottazzi on 11/08/22.
//


#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>
#import "Reminder.h"

@interface geoReminder : MKPointAnnotation

- (instancetype) initWithReminder: (Reminder *) reminder;


@end

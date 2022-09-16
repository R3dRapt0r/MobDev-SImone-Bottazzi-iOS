//
//  geoReminder.m
//  progetto_ios
//
//  Created by Simone Bottazzi on 11/08/22.
//

#import "geoReminder.h"

@implementation geoReminder

- (instancetype) initWithReminder:(Reminder *)reminder{
    if(self = [super init]){
        self.title = reminder.title;
        self.subtitle = reminder.subtitle;
        self.coordinate = CLLocationCoordinate2DMake(reminder.latitude, reminder.longitude);
    }
    return self;
}

@end

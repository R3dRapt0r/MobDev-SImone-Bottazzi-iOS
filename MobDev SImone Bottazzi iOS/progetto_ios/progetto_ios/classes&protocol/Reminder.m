//
//  Reminder.m
//  progetto_ios
//
//  Created by Simone Bottazzi on 10/07/22.
//

#import "Reminder.h"

@implementation Reminder

- (instancetype) initWithParams: (NSString *)title : (NSString *)subtitle : (double) longitude : (double) latitude : (NSDate *) date : (bool) active{
    if(self = [super init])
    {
        self.title = title;
        self.subtitle = subtitle;
        self.longitude = longitude;
        self.latitude = latitude;
        self.date = date;
        self.active = active;
        self.completed = false;
        CLLocationCoordinate2D coord = CLLocationCoordinate2DMake(self.latitude, self.longitude);
        NSString *identifier = [[NSString alloc]initWithFormat:@"radiusof%@%@", self.title, self.subtitle];
        self.region = [[CLCircularRegion alloc] initWithCenter:coord radius:300 identifier:identifier];
        self.region.notifyOnExit = NO;
        self.region.notifyOnEntry = YES;
    }
    return self;
}

@end

//
//  MapViewController.h
//  progetto_ios
//
//  Created by Simone Bottazzi on 08/08/22.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "geoReminder.h"
#import "TableViewController.h"
#import "Reminder.h"

@interface MapViewController : UIViewController <MKMapViewDelegate>
@property NSMutableArray *receivedReminderList;
@property (strong, nonatomic) CLLocationManager *locationmanager;
@property (weak, nonatomic) IBOutlet MKMapView *myMap;
@end

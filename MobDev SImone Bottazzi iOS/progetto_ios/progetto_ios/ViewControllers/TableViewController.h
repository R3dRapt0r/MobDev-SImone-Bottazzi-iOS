//
//  TableViewController.h
//  progetto_ios
//
//  Created by Simone Bottazzi on 13/07/22.
//

#import <UIKit/UIKit.h>
#import <UserNotifications/UserNotifications.h>
#import "Reminder.h"
#import "Protocol.h"
#import "CoreLocation/CoreLocation.h"

@interface TableViewController : UIViewController <sendingReminderProtocol, UITableViewDelegate, UITableViewDataSource, UNUserNotificationCenterDelegate, CLLocationManagerDelegate>
@property (weak, nonatomic) IBOutlet UITableView *reminderTableView;
@property (nonatomic) id <sendingReminderProtocol> delegate;
@property UNUserNotificationCenter *notificationcenter;
@property (strong, nonatomic) CLLocationManager *locationmanager;

@end

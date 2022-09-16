//
//  ViewController.h
//  progetto_ios
//
//  Created by Simone Bottazzi on 10/07/22.
//

#import <UIKit/UIKit.h>
#import <UserNotifications/UserNotifications.h>
#import "Protocol.h"
#import "MapKit/MapKit.h"
#import "TableViewController.h"
#import "Reminder.h"

@interface ViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITextField *reminderTitle;
@property (weak, nonatomic) IBOutlet UIDatePicker *reminderDate;
@property (weak, nonatomic) IBOutlet UITextField *reminderSubtitle;
@property (weak, nonatomic) IBOutlet UITextField *reminderLocation;
@property (strong, nonatomic) CLLocationManager* locationmanager;
//@property (strong, nonatomic) TableViewController* passedtableviewcontroller;

- (IBAction)reminderAdd:(id)sender;
- (IBAction)dateChanged:(id)sender;

//serve per poter passare il reminder al tableviewcontroller quando si torna "indietro"
//dopo aver creato il reminder
@property (nonatomic) id <sendingReminderProtocol> delegate;



@end


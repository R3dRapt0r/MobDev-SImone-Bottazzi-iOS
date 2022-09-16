//
//  ViewController.m
//  progetto_ios
//
//  Created by Simone Bottazzi on 10/07/22.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //imposto la data minima selezionabile del date picker a quella attuale
    [_reminderDate setMinimumDate: [NSDate date]];
}

- (IBAction)dateChanged:(id)sender {
    
}

- (IBAction)reminderAdd:(id)sender {
    //prendo le coordinate facendo il forward geocoding partendo dal nome della posizione passata dall utente
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    [geocoder geocodeAddressString:_reminderLocation.text completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
            if(error)
            {
                NSLog(@"Errore: %@",error);
            }
            else{
                CLLocationCoordinate2D coordd = [placemarks objectAtIndex:0].location.coordinate;
                NSLog(@"%f %f",coordd.latitude,coordd.longitude);
                //passo le coordinate per impostare il reminder
                [self reminerSetup:coordd];
            }
    }];
}

- (void) reminerSetup:(CLLocationCoordinate2D) coord{
    double latitude = coord.latitude;
    double longitude = coord.longitude;
    Reminder *reminder = [[Reminder alloc]initWithParams:_reminderTitle.text : _reminderSubtitle.text : longitude :latitude :_reminderDate.date : true];

    if([CLLocationManager isMonitoringAvailableForClass: CLCircularRegion.self])
    {
        [self.locationmanager startMonitoringForRegion:reminder.region];
    }
    //invio il reminder al table view controller
    [self.delegate send:reminder];
    [self dismissViewControllerAnimated:true completion:nil];
}

@end

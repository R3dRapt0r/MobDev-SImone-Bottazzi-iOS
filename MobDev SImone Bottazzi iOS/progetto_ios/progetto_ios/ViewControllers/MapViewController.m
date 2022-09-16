//
//  MapViewController.m
//  progetto_ios
//
//  Created by Simone Bottazzi on 08/08/22.
//

#import "MapViewController.h"

@interface MapViewController ()

- (void) centerMapToLocation:(CLLocationCoordinate2D)location
                        zoom:(double)zoom;

@end

@implementation MapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.myMap.delegate = self;
    [self.myMap showAnnotations:self.myMap.annotations animated:true];
    
    CLLocationCoordinate2D defaultCoord  = CLLocationCoordinate2DMake(45, 9);
    
    if ([self.locationmanager respondsToSelector:@selector(requestAlwaysAuthorization)]) {
        [self centerMapToLocation:self.locationmanager.location.coordinate zoom: 1];
    }
    else{
        [self centerMapToLocation:defaultCoord zoom: 1];
    }
    
    for (int i = 0; i < self.receivedReminderList.count; i++) {
        //mi assicuro che l ogetto passato sia un reminder, per poi salvarlo in un nuovo reminder
        //controllo che non sia scaduto/completato prima di aggoiungerlo
        if([[self.receivedReminderList objectAtIndex:i] isKindOfClass: Reminder.class]){
            Reminder *r = (Reminder *) [self.receivedReminderList objectAtIndex: i];
            if(r.active && !r.completed)
            {
                geoReminder *georeminder = [[geoReminder alloc] initWithReminder:r];
                [self.myMap addAnnotation:georeminder];
            }
        }
    }
}

//metodo che viene invocato all'aggiunta di una annotazione alla mappa per customizzarla
- (MKAnnotationView *)mapView: (MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation{
    static NSString *AnnotationIdentifer = @"MapAnnotationView";
    
    MKAnnotationView *view = [mapView dequeueReusableAnnotationViewWithIdentifier:AnnotationIdentifer];
    
    if(!view){
        view = [[MKPinAnnotationView alloc] initWithAnnotation:annotation
                                               reuseIdentifier:AnnotationIdentifer];
        view.canShowCallout = YES;
    }
    
    view.annotation = annotation;
    
    //view.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeInfoDark];
    //view.leftCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeClose];
    
    return view;
}

//funzione richiamata alla pressione di un bottone sulla pinannotation

- (void) mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control{
    
}

// si centra la mappa in base alle coordinate passate e allo zoom
- (void)centerMapToLocation:(CLLocationCoordinate2D)location zoom:(double)zoom {
    MKCoordinateRegion mapRegion;
    mapRegion.center = location;
    mapRegion.span.latitudeDelta = zoom;
    mapRegion.span.longitudeDelta = zoom;
    [self.myMap setRegion:mapRegion];
}

@end

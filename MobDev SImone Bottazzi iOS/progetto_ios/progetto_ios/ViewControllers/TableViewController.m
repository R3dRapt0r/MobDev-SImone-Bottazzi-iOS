//
//  TableViewController.m
//  progetto_ios
//
//  Created by Simone Bottazzi on 13/07/22.
//

#import "TableViewController.h"
#import "ViewController.h"
#import "MapViewController.h"

NSMutableArray *reminderList;
bool isGrantedNotificationAccess;

@interface TableViewController ()

@end

@implementation TableViewController

- (BOOL) isExpiredDate : (NSDate *) date1 {
    NSDate *date2 = NSDate.date;
    if ([date1 compare: date2] == NSOrderedDescending)
        return false;
    else
        return true;
}

//controllo la lista di promemoria, inviando la notifica per quelli scaduti,
//ignorando quelli che non sono piu attivi (gia notificati)
- (void) checkIfExpired{
    printf("Called checkIfExpired \n");
    for(Reminder* reminder in reminderList)
    {
        //se la data passata viene dopo quella attuale, è scaduta
        //imposto lo stato ad inattivo
        if([self isExpiredDate: reminder.date] && reminder.active && !reminder.completed)
        {
            reminder.active = false;
            [_reminderTableView reloadData];
            //parte notifica
            //se l utente ha acconsentito a ricevere notifiche, invio
            if(isGrantedNotificationAccess){
                _notificationcenter = [UNUserNotificationCenter currentNotificationCenter];
                
                UNMutableNotificationContent *content = [[UNMutableNotificationContent alloc] init];
                
                content.title = @"Promemoria";
                content.body = [NSString stringWithFormat: @"%@", reminder.title];
                content.sound = [UNNotificationSound defaultSound];
                
                UNTimeIntervalNotificationTrigger *trigger = [UNTimeIntervalNotificationTrigger triggerWithTimeInterval: 1 repeats: NO];
                
                //imposto la richiesta per la notifica
                UNNotificationRequest *request = [UNNotificationRequest requestWithIdentifier:@"UILocalNotification" content: content trigger: trigger];
                
                [_notificationcenter addNotificationRequest: request withCompletionHandler: nil];
            }
        }
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.notificationcenter.delegate = self;
     
    self.locationmanager = [[CLLocationManager alloc]init];
    self.locationmanager.delegate = self;
    self.locationmanager.desiredAccuracy = kCLLocationAccuracyBest;
    self.locationmanager.distanceFilter = 100;
    [self.locationmanager requestAlwaysAuthorization];
    //[self.locationmanager startMonitoringSignificantLocationChanges];
    [self.locationmanager startUpdatingLocation];
    
    if(CLLocationManager.locationServicesEnabled){
        NSLog(@"Location services ok");
    }
    else{
        NSLog(@"Location services not ok");
    }
    
    if ([self.locationmanager respondsToSelector:@selector(requestAlwaysAuthorization)]) {
        [self.locationmanager requestAlwaysAuthorization];
    }
    else{
        NSLog(@"Location services not enabled by the user");
    }

    isGrantedNotificationAccess = false;
    
    //invio la richiesta all utente di ricevere le notifiche
    _notificationcenter = [UNUserNotificationCenter currentNotificationCenter];
    
    UNAuthorizationOptions options = UNAuthorizationOptionAlert + UNAuthorizationOptionSound;
    
    //se l utente accetta di ricevere notifiche imposto il valore a true
    [_notificationcenter requestAuthorizationWithOptions:options completionHandler:^(BOOL granted, NSError * _Nullable error) {
        isGrantedNotificationAccess = true;
    }];
    
    //inizializzo la lista dei reminder
    reminderList = [[NSMutableArray alloc] init];
    
    self.reminderTableView.dataSource = self;
    self.reminderTableView.delegate = self;
    
    [self runTimer];
}

//sezione di definizione della tableview
//definisco il numero di righe in base a quanti reminder ci sono nella mia lista, in base a
//quanti elemnti ho nella lista di reminder
- (NSInteger) tableView: (UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [reminderList count];
}

//per ogni cella con id = cell inserisco il titolo del mio reminder corrispondente usando
//l indice di riga indexpath.row
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    Reminder *reminder = reminderList[indexPath.row];
    cell.textLabel.text = reminder.title;
    //imposto i colori in base allo stato del reminder
    if(reminder.active && reminder.completed)
    {
        [cell setBackgroundColor: UIColor.greenColor];
        [cell setUserInteractionEnabled: false];
    }
    else if (!reminder.active && !reminder.completed)
    {
        [cell setBackgroundColor:UIColor.redColor];
        [cell setUserInteractionEnabled: false];
    }
    else
        [cell setBackgroundColor: UIColor.grayColor];
    return cell;
}

//per completare un reminder
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    Reminder *reminder = reminderList[indexPath.row];
    reminder.completed = true;
    [_reminderTableView reloadData];
}

//ogni minuto controllo se sono scaduti promemoria, chiamando la funzione checkifexpired
- (void) runTimer{
    [
    NSTimer scheduledTimerWithTimeInterval:30.0
    target: self
    selector: @selector(checkIfExpired)
    userInfo:nil
    repeats:YES
    ];
}

//sezione dei delegate per ottenere l oggetto creato reminder nel viewcontroller e aggiungerlo
//alla lista dei reminder
//ogni volta che un reminder è aggiunto aggiorno la viewtable ri-eseguendo le funzioni di generazione della tabella
- (void) send : (Reminder *) reminder{
    [reminderList addObject: reminder];
    [_reminderTableView reloadData];
    
}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.identifier isEqualToString:@"gotoMap"]){
        MapViewController *mapviewcontroller = [segue destinationViewController];
        mapviewcontroller.locationmanager = self.locationmanager;
        mapviewcontroller.receivedReminderList = reminderList;
    }
    if([segue.identifier isEqualToString:@"gotoAddReminder"]){
        ViewController *viewControllerInstance = [segue destinationViewController];
        viewControllerInstance.locationmanager = self.locationmanager;
        //viewControllerInstance.passedtableviewcontroller = self;
        viewControllerInstance.delegate = self;
    }
}

//funzione chiamata una volta che il location manager rileva l'entrara nel raggio di in una region
//che stava monitorando (massimo di region monitorabili: 20)
- (void) locationManager:(CLLocationManager *)manager didEnterRegion:(CLRegion *)region{
    
    UNMutableNotificationContent *content = [[UNMutableNotificationContent alloc] init];
    
    for (Reminder *reminder in reminderList) {
        
        //cerco la region in cui sono entrato controllando nella lista dei promemoria quale di questi
        //corrisponde all id della region, poi preparo la notifica
        if([reminder.region.identifier isEqualToString: region.identifier]){
            if(!reminder.completed && reminder.active){
                content.title = reminder.title;
                content.body = [NSString stringWithFormat: @"%@", reminder.subtitle];
                content.sound = [UNNotificationSound defaultSound];
                
                UNTimeIntervalNotificationTrigger *trigger = [UNTimeIntervalNotificationTrigger triggerWithTimeInterval: 1 repeats: NO];
                
                //imposto la richiesta per la notifica
                UNNotificationRequest *request = [UNNotificationRequest requestWithIdentifier:@"UILocalNotification" content: content trigger: trigger];
                
                [_notificationcenter addNotificationRequest: request withCompletionHandler:^(NSError * _Nullable error) {
                    if(error != nil) NSLog(@"Errore notifica: %@", error);
                }];
                break;
            }
        }
    }
}

- (void) locationManager:(CLLocationManager *)manager didExitRegion:(CLRegion *)region{
    for(Reminder *reminder in reminderList)
    {
        NSLog(@"Exited region with identifier: %@", reminder.region.identifier);
    }
}

-(void) locationManager:(CLLocationManager *)manager didStartMonitoringForRegion:(CLRegion *)region{
    NSLog(@"Started monitoring region: %@", region.description);
}

- (void)locationManager:(CLLocationManager *)manager monitoringDidFailForRegion:(CLRegion *)region withError:(NSError *)error{
    NSLog(@"%@", manager.location);
    NSLog(@"%@", region.description);
    NSLog(@"Error while monitoring region: %@", error);
}

- (void) locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations{
    NSLog(@"Updated location to: %@", manager.location);
}

@end

//
//  Protocol.h
//  progetto_ios
//
//  Created by Simone Bottazzi on 15/07/22.
//

#import <Foundation/Foundation.h>
#import "Reminder.h"

@protocol sendingReminderProtocol

- (void) send : (Reminder *) reminder;

@end

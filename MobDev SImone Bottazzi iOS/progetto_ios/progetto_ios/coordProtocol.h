//
//  coordProtocol.h
//  progetto_ios
//
//  Created by Simone Bottazzi on 10/08/22.
//

#import <Foundation/Foundation.h>
#import "Reminder.h"

@protocol sending

- (void) send : (Reminder *) reminder;

@end

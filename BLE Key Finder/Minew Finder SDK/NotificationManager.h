//
//  NotificationManager.h
//  MinewDeviceSDKDemo
//
//  Created by SACRELEE on 12/28/16.
//  Copyright © 2016 MinewTech. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NotificationManager : NSObject

+ (void)requestAuthor;

+ (void)pushNotification:(NSString *)message, ...;

@end

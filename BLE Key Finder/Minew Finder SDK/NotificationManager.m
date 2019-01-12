//
//  NotificationManager.m
//  MinewDeviceSDKDemo
//
//  Created by SACRELEE on 12/28/16.
//  Copyright © 2016 MinewTech. All rights reserved.
//

#import "NotificationManager.h"
#import <UserNotifications/UserNotifications.h>
#import <UIKit/UIKit.h>

@implementation NotificationManager

+ (void)pushNotification:(NSString *)message, ...
{
    UIApplication *app = [UIApplication sharedApplication];
    
    if (app.applicationState != UIApplicationStateBackground)
        return ;
    
    
    va_list argList;
    va_start( argList, message);
    NSString *fullMessage = [[NSMutableString alloc]initWithFormat:message arguments:argList];
    va_end(argList);
    
    UILocalNotification *notification = [[UILocalNotification alloc]init];
    notification.alertBody = fullMessage;
    notification.alertAction = @"view";
    notification.alertLaunchImage = @"Defualt";
    notification.applicationIconBadgeNumber = [UIApplication sharedApplication].applicationIconBadgeNumber + 1;
    notification.userInfo = @{@"peripheral": fullMessage, @"tag": @"keys"};
    notification.soundName = UILocalNotificationDefaultSoundName;
    
    [app presentLocalNotificationNow:notification];
}

+ (void)requestAuthor
{

    [[UIApplication sharedApplication] registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeAlert|UIUserNotificationTypeBadge|UIUserNotificationTypeSound categories:nil]];

}

@end

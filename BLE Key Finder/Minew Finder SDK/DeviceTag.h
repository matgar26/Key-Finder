//
//  CoreDevice.h
//  MinewDeviceSDKDemo
//
//  Created by SACRELEE on 12/28/16.
//  Copyright © 2016 MinewTech. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MinewDevice.h"

@class DeviceTag;

typedef void(^BindBlock)(BOOL success, DeviceTag *tag);

@protocol DeviceTagDelegate <NSObject>

@optional

- (void)didTagUpdateValue:(DeviceTag *)tag;

- (void)didTagSendInstruction:(InstrucIndex)index result:(BOOL)success;

- (void)didTagReceiveInstruction:(InstrucIndex)index;

@end



@interface DeviceTag : NSObject


@property (nonatomic, strong) MinewDevice *device;

@property (nonatomic, weak) id<DeviceTagDelegate> delegate;

@property (nonatomic, strong) BindBlock bindBlock;

- (instancetype)initWithDevice:(MinewDevice *)device;

- (void)startAlarmOniPhone;

- (void)stopAlarmOniPhone;


@end

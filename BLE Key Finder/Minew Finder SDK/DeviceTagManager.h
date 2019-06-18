//
//  CoreDeviceManager.h
//  MinewDeviceSDKDemo
//
//  Created by SACRELEE on 12/28/16.
//  Copyright © 2016 MinewTech. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MinewDeviceManager.h"
#import "DeviceTag.h"

typedef void(^BindBlock)(BOOL success, DeviceTag *tag);

@protocol DeviceTagManagerDelegate <NSObject>

@optional
- (void)didManagerScanTags:(NSArray<DeviceTag *> *)tags;
- (void)didManagerUpdateBindTags:(NSArray<DeviceTag *> *)tags;
- (void)didManagerUpdateBluetooth:(BluetoothState)state;
- (void)didManagerUpdateTag:(DeviceTag *)tag LinkState:(DeviceLinkState)state;

@end

@interface DeviceTagManager : NSObject

@property (nonatomic, weak) id<DeviceTagManagerDelegate> delegate;

@property (nonatomic, strong, readonly) NSMutableArray<DeviceTag *> *scannedTags;

@property (nonatomic, strong, readonly) NSMutableArray<DeviceTag *> *bindTags;

@property (nonatomic, assign, readonly) BluetoothState bluetoothState;

@property (nonatomic, assign) BOOL disableAutoProgress;


+ (DeviceTagManager *)sharedInstance;

- (void)startScan;

- (void)stopScan;

- (void)connect:(DeviceTag *)tag;

- (void)disconnect:(DeviceTag *)tag;

- (void)bind:(DeviceTag *)tag completion:(BindBlock)handler;

- (void)unbind:(DeviceTag *)tag;

- (void)reset;

- (void)archiveBindTags;

@end

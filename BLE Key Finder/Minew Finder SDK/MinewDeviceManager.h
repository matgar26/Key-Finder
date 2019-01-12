//
//  MinewDeviceManager.h
//  ProximityTagSDKDEMO
//
//  Created by SACRELEE on 8/31/16.
//  Copyright © 2016 com.YLWL. All rights reserved.
//

#import <Foundation/Foundation.h>

// enum of bluetooth state
typedef NS_ENUM( NSInteger, BluetoothState) {
    BluetoothstateUnknown = 0,
    BluetoothStatePowerOn,
    BluetoothStatePowerOff,
};

// enum of device link state
typedef NS_ENUM( NSInteger, DeviceLinkState){
    
    DeviceLinkState_Connecting = 1,   // connecting
    DeviceLinkState_Connected,        // connected
    DeviceLinkState_ConnectFailed,    // connect failed
    DeviceLinkState_Disconnected,       // disconnect
};

@class MinewDevice, MinewDeviceManager;

@protocol MinewDeviceManagerDelegate <NSObject>

@optional

/**
 *  if device link state changed , this method will call back
 *
 *  @param manager  instance of a devicemanager
 *  @param device  which device changed
 *  @param state   change to which state
 */
- (void)manager:(MinewDeviceManager *)manager didDevice:(MinewDevice *)device updateLinkState:(DeviceLinkState)state;

/**
 *  the state change of bluetoothstate
 *
 *  @param manager instance of a devicemanager
 *  @param state   current bluetooth state
 */
- (void)manager:(MinewDeviceManager *)manager didUpdateBluetoothState:(BluetoothState)state;

/**
 *  you can get all found devices by using this delegate method
 *
 *  @param manager instance of a devicemanager
 *  @param devices all found devices
 */
- (void)manager:(MinewDeviceManager *)manager didScanDevices:(NSArray <MinewDevice *>*)devices;

/**
 *  if manager found a new device this method will call back
 *
 *  @param manager instance of a devicemanager
 *  @param devices all new devices
 */
- (void)manager:(MinewDeviceManager *)manager appearDevices:(NSArray <MinewDevice *> *)devices;

/**
 *  if a device can't be scanned again, the manager think it is disappeared.
 *
 *  @param manager instance of a devicemanager
 *  @param devices all disappeared devices
 */
- (void)manager:(MinewDeviceManager *)manager disappearDevices:(NSArray<MinewDevice *> *)devices;

/**
 *  if you bind some devices this method will call back Periodically, you can get newest state of all bind devices
 *
 *  @param manager instance of a devicemanger
 *  @param devices all bind devices
 */
- (void)manager:(MinewDeviceManager *)manager didUpdateBindDevice:(NSArray <MinewDevice *>*)devices;

@end

@interface MinewDeviceManager : NSObject

@property (nonatomic, weak) id<MinewDeviceManagerDelegate> delegate;

// all scanned devices after execute - (void)startScan method.
@property (nonatomic, strong, readonly) NSArray<MinewDevice *> *scannedDevices;

// current bluetooth state
@property (nonatomic, assign, readonly) BluetoothState bluetoothState;

// all bind devices
@property (nonatomic, strong, readonly) NSArray<MinewDevice *> *bindDevices;

// stop all automatic tasks, such as connection, scan and so on,
// Warnning: please don't modify this property at will unless you understand what it happens.
@property (nonatomic, assign) BOOL disableAutoProcessing;

/**
 *  shared instance
 *
 *  @return the shared instance of device manager
 */
+ (MinewDeviceManager *)sharedInstance;

/**
 *  start scan for devices , if you bind some devices, the manager will try to connect automatically.
 */
- (void)startScan;


/**
 *  stop scan for devices.
 */
- (void)stopScan;

/**
 *  connect to a device
 *
 *  @param device the device which you want to connect.
 */
- (void)connect:(MinewDevice *)device;

/**
 *  disconnect from a device
 *
 *  @param device the device which you want to disconnect.
 */
- (void)disconnect:(MinewDevice *)device;

/**
 *  bind a new device.
 *
 *  @param device the device which you want to bind.
 */
- (void)bind:(MinewDevice *)device;

/**
 *  remove a bind device.
 *
 *  @param device the bind device which you want to remove
 */
- (void)unBind:(MinewDevice *)device;

/**
 *  disconnect all bind devices and remove them from bind device queue.
 */
- (void)reset;



@end

//
//  MinewDevice.h
//  ProximityTagSDKDEMO
//
//  Created by SACRELEE on 8/31/16.
//  Copyright © 2016 com.YLWL. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MinewDeviceValue.h"

// Instruction enumerate.
typedef NS_ENUM(NSInteger, InstrucIndex){
    
    // phone to device
    InstrucIndex_Search = 1,     // search for device
    InstrucIndex_CancelSearch,   // cancel searching.
    InstrucIndex_LoseAlertHigh,  // device will alert when disconnect
    InstrucIndex_LoseAlertNone,  // device won't alert when disconnect
    
    // device to phone
    InstrucIndex_ClickOne = 100,   // click device button one time.
    
    InstrucIndex_KeySuccess = 1000,
    InstrucIndex_KeyFailed
};


@class MinewDevice;
@protocol MinewDeviceDelegate <NSObject>

@optional

/**
 *  this method will call back if the value of device updated.
 *
 *  @param device  which device update a value.
 *  @param index   index of value which updated.
 */
- (void)device:(MinewDevice *)device didUpdateValue:(ValueIndex)index;


/**
 *  if you send a instruction to device, this method will call back, then you can know if iphone sent instruction successfully,
 *
 *  @param index   index of instruction
 *  @param device  which device you sent instruction
 *  @param success if sent successfully.
 */
- (void)didSendInstruction:(InstrucIndex)index toDevice:(MinewDevice *)device result:(BOOL)success;

/**
 *  if the device send a instruction to iphone, this method will call back
 *
 *  @param index  index of instruction
 *  @param device which device sent this instruction
 */
- (void)didReceiveInstruction:(InstrucIndex)index fromDevice:(MinewDevice *)device;


@end


@interface MinewDevice : NSObject

@property (nonatomic, weak) id<MinewDeviceDelegate> delegate;

/**
 *  get value of device
 *
 *  @param index index of which value you want to get.
 *
 *  @return a MinewDeviceValue Instance
 */
- (MinewDeviceValue *)getValue:(ValueIndex)index;

/**
 *  set value of device
 *
 *  @param value  the MinewDeviceValue instance
 */
- (void)setValue:(MinewDeviceValue *)value;

/**
 *  send a instruction to device, if complete it will call back
 *  - (void)didSendInstruction:(InstrucIndex)index toDevice:(MinewDevice *)device result:(BOOL)success methoud
 *
 *  @param index index of the instruction 
 */
- (void)sendInstruction:(InstrucIndex)index;


@end

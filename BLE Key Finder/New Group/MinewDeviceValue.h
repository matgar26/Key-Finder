//
//  MinewDeviceValue.h
//  ProximityTagSDKDEMO
//
//  Created by SACRELEE on 8/31/16.
//  Copyright © 2016 com.YLWL. All rights reserved.
//

#import <Foundation/Foundation.h>

// enumerate of device values
typedef NS_ENUM(NSInteger, ValueIndex) {
    
    /*   Device propertys   */
    //                                    type        permission      note
    
    // custom name
    ValueIndex_Name = 1,            //    stringValue    W/R
    // headimage
    ValueIndex_HeadImage,           //    dataValue     W/R             a NSData instance of image
    // device name
    ValueIndex_DeviceId,            //    stringValue    R              F2 / F3
    // mac address
    ValueIndex_MacAddress,          //    stringValue    R
    // rssi
    ValueIndex_Rssi,                //    intValue       R
    // mode  using mode
    ValueIndex_Mode,                //    intValue      W/R            1, 2
    // distance
    ValueIndex_Distance,            //    floatValue     R
    // battery level
    ValueIndex_Battery,             //    intValue       R
    // bind status
    ValueIndex_Bind,                //    boolValue      R
    // you can get last time of device disconnect
    ValueIndex_DisappearTime,       //    stringValue    R             yyyy-MM-dd hh:mm:ss
    // you can get last longitude of device disconnect
    ValueIndex_DisappearLong,       //    floatValue     R
    // you can get last latitude of device disconnect
    ValueIndex_DisappearLati,       //    floatValue     R
    // if device connected
    ValueIndex_Connected,           //    boolValue      R
    // when device disconnect if it alert, see the demo
    ValueIndex_DeviceLoseAlert,     //    boolValue      R / W
    // if app is searching the device
    ValueIndex_Search,              //    boolValue      R
    // when device disconnect if app alert, see the demo
    ValueIndex_AppLoseAlert,        //    boolValue      R / W
    
    // if device support set alarmdelay and alarmdistance
    ValueIndex_FeatureSupport,      //    boolValue      R
    // control disconnect distance between device and iPhone
    ValueIndex_AlarmDistance,       //    intValue       R / W        1 - 8
    // control alarm delay time when disconnect.
    ValueIndex_AlarmDelay,          //    intValue       R / W        0 - 8
    
    /* Device data handle */
    ValueIndex_DeviceData = 1000,   //    dataValue      R
};

@interface MinewDeviceValue : NSObject

/**
 *  you can get a device value instance
 *
 *  @param index index of this data
 *  @param value this param can be data/string/integer/float/bool
 *
 *  @return a instance of MinewDeviceValue with the giving index and value
 */
+ (MinewDeviceValue *)index:(ValueIndex)index value:(id)value;

// the index of this value
@property (nonatomic, readonly, assign) ValueIndex index;

// integer value
@property (nonatomic, readonly, assign) NSInteger intValue;

// float value
@property (nonatomic, readonly, assign) float floatValue;

// string value
@property (nonatomic, readonly, copy) NSString *stringValue;

// data value
@property (nonatomic, readonly, copy) NSData  *dataValue;

// bool value
@property (nonatomic, readonly, assign) BOOL boolValue;


@end

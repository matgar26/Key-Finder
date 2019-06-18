//
//  CoreDeviceManager.m
//  MinewDeviceSDKDemo
//
//  Created by SACRELEE on 12/28/16.
//  Copyright © 2016 MinewTech. All rights reserved.
//

#import "DeviceTagManager.h"
#import "NotificationManager.h"
#import "AudioPlayerTool.h"


#define dataPath [NSHomeDirectory() stringByAppendingString:@"/Library/devices.archive"]

@interface DeviceTagManager ()<MinewDeviceManagerDelegate>

@property (nonatomic, strong) MinewDeviceManager *manager;

@property (nonatomic, strong) DeviceTag *bindingTag;

@end

@implementation DeviceTagManager

+ (DeviceTagManager *)sharedInstance
{
    static DeviceTagManager *dm = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        dm = [[DeviceTagManager alloc]init];
    });
    return dm;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.manager = [MinewDeviceManager sharedInstance];
        [self unArchiveBindTags];
    }
    return self;
}

- (void)startScan
{
    [self.manager startScan];
}

- (void)stopScan
{
    [self.manager stopScan];
}

- (void)connect:(DeviceTag *)tag
{
    [self.manager connect:tag.device];
}

- (void)disconnect:(DeviceTag *)tag
{
    [self.manager disconnect:tag.device];
}

- (void)setDisableAutoProgress:(BOOL)disableAutoProgress
{
    _disableAutoProgress = disableAutoProgress;
    
    if (disableAutoProgress) {
        [self stopScan];
    }
    else
        [self startScan];
    
    self.manager.disableAutoProcessing = disableAutoProgress;
}


- (void)bind:(DeviceTag *)tag completion:(BindBlock)handler
{
    _bindingTag = tag;
    
    __weak DeviceTagManager *weakSelf = self;
    [self stopScan];
    _bindingTag.bindBlock = ^(BOOL success, DeviceTag *aTag) {
        
        __strong DeviceTagManager *strongSelf = weakSelf;
        if (success) {
            [strongSelf.manager bind:aTag.device];
            [strongSelf.bindTags addObject:aTag];
            [strongSelf archiveBindTags];
        }
        
        if (handler)
            handler(success, aTag);
    };
    
    [self connect:_bindingTag];
}


- (void)unbind:(DeviceTag *)tag
{
    [self.manager unBind:tag.device];
    [self.bindTags removeObject:tag];
    [self archiveBindTags];
}

- (void)reset
{
    [self.manager reset];
    [_bindTags removeAllObjects];
    [self archiveBindTags];
}

- (void)archiveBindTags
{
    if (_bindTags.count)
        [NSKeyedArchiver archiveRootObject:_bindTags toFile:dataPath];
    else
        [[NSFileManager defaultManager] removeItemAtPath:dataPath error:nil];
    
    NSLog(@"archive %lu devices", (unsigned long)_bindTags.count);
}

- (void)unArchiveBindTags
{
    if (!_bindTags)
        _bindTags = [NSMutableArray array];
    
    NSArray *bindTags = [NSKeyedUnarchiver unarchiveObjectWithFile:dataPath];
    
    [_bindTags addObjectsFromArray:bindTags];
    
    for (NSInteger i = 0; i < _bindTags.count; i ++)
    {
        MinewDevice *device = ((DeviceTag *)_bindTags[i]).device;
        
        [self.manager bind:device];
    }
    NSLog(@"unArchive %lu devices.", (unsigned long)bindTags.count);
}


- (BluetoothState)bluetoothState
{
    return self.manager.bluetoothState;
}

- (void)setManager:(MinewDeviceManager *)manager
{
    _manager = manager;
    _manager.delegate = self;
}


#pragma mark ***********************************MinewDeviceManager Delegate
- (void)manager:(MinewDeviceManager *)manager appearDevices:(NSArray<MinewDevice *> *)devices
{
   
}


- (void)manager:(MinewDeviceManager *)manager didScanDevices:(NSArray<MinewDevice *> *)devices
{
    NSMutableArray *tags = [NSMutableArray arrayWithCapacity:devices.count];
    
    for ( NSInteger i = 0; i < devices.count; i ++)
    {
        DeviceTag *tag = [[DeviceTag alloc]initWithDevice:devices[i]];
        [tags addObject:tag];
    }
    
    if ([self.delegate respondsToSelector:@selector(didManagerScanTags:)])
        [self.delegate didManagerScanTags:tags];
}

- (void)manager:(MinewDeviceManager *)manager disappearDevices:(NSArray<MinewDevice *> *)devices
{
    
}

- (void)manager:(MinewDeviceManager *)manager didUpdateBindDevice:(NSArray<MinewDevice *> *)devices
{
    if (self.bindTags && [self.delegate respondsToSelector:@selector(didManagerUpdateBindTags:)])
        [self.delegate didManagerUpdateBindTags:self.bindTags];
}

- (void)manager:(MinewDeviceManager *)manager didUpdateBluetoothState:(BluetoothState)state
{
    if (state != BluetoothStatePowerOn)
        [NotificationManager pushNotification:@"Bluetooth state is poweroff!!"];
    
    if ([self.delegate respondsToSelector:@selector(didManagerUpdateBluetooth:)])
        [self.delegate didManagerUpdateBluetooth:state];
}

- (void)manager:(MinewDeviceManager *)manager didDevice:(MinewDevice *)device updateLinkState:(DeviceLinkState)state
{
    DeviceTag *tag = [self getBindTag:device];
    
    if (tag)
    {
        if (state == DeviceLinkState_Disconnected && ![self muteStatus])
        {
            [NotificationManager pushNotification:@"%@ disconnect from your iPhone.", [tag.device getValue:ValueIndex_MacAddress].stringValue];
            
            if ([device getValue:ValueIndex_AppLoseAlert].boolValue)
               [tag startAlarmOniPhone];
        }
        
        if(state == DeviceLinkState_Connected)
        {
            [NotificationManager pushNotification:@"%@ is connected.", [tag.device getValue:ValueIndex_MacAddress].stringValue];
            [tag stopAlarmOniPhone];
        }
        
        if ([self.delegate respondsToSelector:@selector(didManagerUpdateTag:LinkState:)])
            [self.delegate didManagerUpdateTag:tag LinkState:state];
    }
    else
        NSLog(@"a tag change linkstate, but it didn't bind.");

}

- (DeviceTag *)getBindTag:(MinewDevice *)device
{
    for ( NSInteger i = 0; i < _bindTags.count; i ++)
    {
        DeviceTag *tag = _bindTags[i];
        
        if ([[tag.device getValue:ValueIndex_MacAddress].stringValue isEqualToString:[device getValue:ValueIndex_MacAddress].stringValue])
            return tag;
    }
    return nil;
}

- (BOOL)muteStatus
{
    return [[NSUserDefaults standardUserDefaults] boolForKey:@"MUTESTATUS"];
}




@end

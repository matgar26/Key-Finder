//
//  CoreDevice.m
//  MinewDeviceSDKDemo
//
//  Created by SACRELEE on 12/28/16.
//  Copyright © 2016 MinewTech. All rights reserved.
//

#import "DeviceTag.h"
#import "MinewDevice.h"
#import "NotificationManager.h"
#import "AudioPlayerTool.h"

@interface DeviceTag ()<MinewDeviceDelegate>

@property (nonatomic, strong) AudioPlayerTool *apt;

@end

@implementation DeviceTag
{
    BOOL _searchingiPhone;
}

- (instancetype)initWithDevice:(MinewDevice *)device
{
    self = [super init];
    if (self) {
        self.device = device;
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    
    if (self)
    {
        self.device = [aDecoder decodeObjectForKey:@"DeviceString"];
    }
    
    return self;
}

- (AudioPlayerTool *)apt
{
    if (!_apt)
        _apt = [[AudioPlayerTool alloc]init];
    
    return _apt;
}

- (void)encodeWithCoder:(NSCoder *)encoder
{
    [encoder encodeObject:self.device forKey:@"DeviceString"];
}


- (void)setDevice:(MinewDevice *)device
{
    _device = device;
    _device.delegate = self;
}

- (void)device:(MinewDevice *)device didUpdateValue:(ValueIndex)index
{
    if ([self.delegate respondsToSelector:@selector(didTagUpdateValue:)])
        [self.delegate didTagUpdateValue:self];
}

- (void)didSendInstruction:(InstrucIndex)index toDevice:(MinewDevice *)device result:(BOOL)success
{
    if ([self.delegate respondsToSelector:@selector(didTagSendInstruction:result:)])
        [self.delegate didTagSendInstruction:index result:success];
}

- (void)didReceiveInstruction:(InstrucIndex)index fromDevice:(MinewDevice *)device
{
    if (index == InstrucIndex_ClickOne)
    {
        _searchingiPhone = !_searchingiPhone;

        NSString *tips = nil;
        
        if ( !_searchingiPhone)
            tips = @"device is searching phone.";
        else if(index == InstrucIndex_CancelSearch)
            tips = @"device stop searching phone";
        
        NSLog(@"%@", tips);

        
        if(!_searchingiPhone)
        {
            [self stopAlarmOniPhone];
            return ;
        }
        
        [NotificationManager pushNotification:@"%@ is searching your iPhone", [_device getValue:ValueIndex_MacAddress].stringValue];
        [self startAlarmOniPhone];
    }
    
    if (index >= InstrucIndex_KeySuccess )
    {
        
        if (_bindBlock) {
            _bindBlock( index == InstrucIndex_KeySuccess? YES: NO, self);
            _bindBlock = nil;
        }
    }
    
    if ([self.delegate respondsToSelector:@selector(didTagReceiveInstruction:)])
        [self.delegate didTagReceiveInstruction:index];
}

- (void)startAlarmOniPhone
{
    [self.apt startPlayingAlarmSound];
}

- (void)stopAlarmOniPhone
{
    [self.apt stopPlayingAlarmSound];
}


@end

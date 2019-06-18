//
//  AudioPlayerTool.h
//  AntiLost
//
//  Created by SACRELEE on 12/09/2016.
//  Copyright © 2016 MinewTech. All rights reserved.
//



#import <Foundation/Foundation.h>

@interface AudioPlayerTool : NSObject

@property (nonatomic, assign, readonly, getter=isPlaying) BOOL playing;

+ (AudioPlayerTool *)sharedInstance;

- (void)startPlayingAlarmSound;

- (void)stopPlayingAlarmSound;

@end


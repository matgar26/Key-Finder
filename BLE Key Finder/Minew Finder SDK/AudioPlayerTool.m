//
//  AudioPlayerTool.m
//  AntiLost
//
//  Created by SACRELEE on 12/09/2016.
//  Copyright © 2016 MinewTech. All rights reserved.
//

#import "AudioPlayerTool.h"
#import <AVFoundation/AVFoundation.h>
#import <UIKit/UIKit.h>

@interface AudioPlayerTool ()

@property (nonatomic, strong) AVAudioPlayer *player;

@end

@implementation AudioPlayerTool

static AudioPlayerTool *sharedAudioPlayer;

+ (AudioPlayerTool *)sharedInstance
{
    if (!sharedAudioPlayer)
    {
        sharedAudioPlayer = [[AudioPlayerTool alloc] init];
    }
    return sharedAudioPlayer;
}

- (AudioPlayerTool *)init
{
    if (self = [super init])
    {
        NSURL *url = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"alarm-sound" ofType:@"wav"]];
        NSError * error;
        _player = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:&error];
    }
    
    return self;
}

- (void)startPlayingAlarmSound
{
    NSError *error;
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:&error];
    
    [[AVAudioSession sharedInstance] setActive:YES error:&error];
    
    [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
    
    self.player.numberOfLoops = 0;
    [_player play];

}

- (void) stopPlayingAlarmSound
{
    if (_player.isPlaying)
    {
        [_player stop];
    }
}

-(BOOL)isPlaying
{
    return _player.isPlaying;
}

@end

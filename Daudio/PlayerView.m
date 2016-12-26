//
//  PlayerView.m
//  Daudio
//
//  Created by Claudius Mbemba on 12/24/16.
//  Copyright © 2016 Claudius Mbemba. All rights reserved.
//

@import AVFoundation;
@import MediaPlayer;
#import "PlayerView.h"
#import "Session.h"
#import <Objection/Objection.h>
#import "UIAlertController+Utils.h"

static NSString *session = @"session";

@interface PlayerView() <AVAudioPlayerDelegate>

@end

@implementation PlayerView {
    AVAudioPlayer *_audioPlayer1, *_audioPlayer2;
    BOOL _isPlaying;
}

objection_requires(session)

- (instancetype)init {
    self = [super init];
    if (self) {
        [JSObjection.defaultInjector injectDependencies:self];
        _isNewSession = YES;
    }
    return self;
}

- (instancetype)initWithSession:(Session *)session {
    self = [super init];
    if (self) {
        self.session = session;
    }
    return self;
}

- (void)player1Active {
    _audioPlayer1.volume = 1.0;
    _audioPlayer2.volume = 0.0;
}

- (void)player2Active {
    _audioPlayer1.volume = 0.0;
    _audioPlayer2.volume = 1.0;
}

#pragma mark Player
- (void)startPlayers {
    _isPlaying = YES;
    [_audioPlayer1 play];
    _audioPlayer1.volume = 1.0;
    [_audioPlayer2 play];
    _audioPlayer2.volume = 0.0;
}

- (void)stopPlayers {
    _isPlaying = NO;
    [_audioPlayer1 stop];
    [_audioPlayer2 stop];
}

- (void)clearPlayerSession {
    self.session = nil;
    _audioPlayer1 = nil;
    _audioPlayer2 = nil;
    _isNewSession = _isPlaying = NO;
}

- (BOOL)playersAreSet {
    return _audioPlayer1 && _audioPlayer2;
}

- (void)setAudioPlayer1:(AVAudioPlayer *)player {
    _audioPlayer1 = player;
    _audioPlayer1.delegate = self;
}

- (void)setAudioPlayer2:(AVAudioPlayer *)player {
    _audioPlayer2 = player;
    _audioPlayer2.delegate = self;
}

#pragma mark AVAudioPlayer Delegates

- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag {
    if ([player isEqual:_audioPlayer1]) {
        [self.delegate playerDidFinishPlaying:[UIAlertController alertWithTitle:@"Song Finished" message:[NSString stringWithFormat:@"%@ has finished playing", self.session.firstTrack.title] actionHandler:nil]];
    } else {
        [self.delegate playerDidFinishPlaying:[UIAlertController alertWithTitle:@"Song Finished" message:[NSString stringWithFormat:@"%@ has finished playing", self.session.secondTrack.title] actionHandler:nil]];
    }
    if (!_audioPlayer1.isPlaying && !_audioPlayer2.isPlaying) {
        [self.delegate playersDidFinishPlaying];
    }
}

@end

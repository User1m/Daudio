//
//  PlayerViewModel.m
//  Daudio
//
//  Created by Claudius Mbemba on 12/24/16.
//  Copyright © 2016 Claudius Mbemba. All rights reserved.
//

@import AVFoundation;
@import MediaPlayer;
#import "PlayerViewModel.h"
#import "Session.h"
#import <Objection/Objection.h>
#import "UIAlertController+Utils.h"

static NSString *session = @"session";
static NSString *delegate = @"delegate";
static NSString *audioPlayer1 = @"audioPlayer1";
static NSString *audioPlayer2 = @"audioPlayer2";
const NSUInteger skipTime = 10;

@interface PlayerViewModel() <AVAudioPlayerDelegate>
@property (nonatomic, strong, readwrite) AVAudioPlayer *audioPlayer1;
@property (nonatomic, strong, readwrite) AVAudioPlayer *audioPlayer2;
@end

@implementation PlayerViewModel

objection_requires(session)

- (instancetype)init {
    self = [super init];
    if (self) {
        [JSObjection.defaultInjector injectDependencies:self];
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
    self.audioPlayer1.volume = 1.0;
    self.audioPlayer2.volume = 0.0;
}

- (void)player2Active {
    self.audioPlayer1.volume = 0.0;
    self.audioPlayer2.volume = 1.0;
}

#pragma mark Player

- (void)startPlayer:(AudioPlayers)player {
    (player == PlayerOne) ? [self.audioPlayer1 play] : [self.audioPlayer2 play];
}

- (void)stopPlayer:(AudioPlayers)player {
    (player == PlayerOne) ? [self.audioPlayer1 stop] : [self.audioPlayer2 stop];
}

- (void)pausePlayer:(AudioPlayers)player {
    (player == PlayerOne) ? [self.audioPlayer1 pause] : [self.audioPlayer2 pause];
}

- (void)resetPlayer:(AudioPlayers)player {
    [self setAudioPlayer:player media:(player == PlayerOne) ? self.session.firstTrack : self.session.secondTrack];
}

- (void)fastFwdPlayer:(AudioPlayers)player {
    (player == PlayerOne) ?
    [self.audioPlayer1 playAtTime:self.audioPlayer1.currentTime + skipTime] :
    [self.audioPlayer2 playAtTime:self.audioPlayer1.currentTime + skipTime];
}

- (void)rewindPlayer:(AudioPlayers)player {
    (player == PlayerOne) ?
    [self.audioPlayer1 playAtTime:self.audioPlayer1.currentTime - skipTime] :
    [self.audioPlayer2 playAtTime:self.audioPlayer1.currentTime - skipTime];
}

- (BOOL)sessionIsNew {
    return self.session.isNewSession;
}

- (void)startPlayers {
    self.isPlaying = YES;
    [self.audioPlayer1 play];
    self.audioPlayer1.volume = 1.0;
    [self.audioPlayer2 play];
    self.audioPlayer2.volume = 0.0;
}

- (void)stopPlayers {
    self.isPlaying = NO;
    [self.audioPlayer1 stop];
    [self.audioPlayer2 stop];
}

- (void)clearPlayerSession {
    self.session = nil;
    self.audioPlayer1 = nil;
    self.audioPlayer2 = nil;
    self.isPlaying = NO;
}

- (BOOL)playersAreSet {
    return self.audioPlayer1 != nil && self.audioPlayer2 != nil;
}

- (void)setSession:(Session *)session {
    _session = session;
    if (session.firstTrack && session.secondTrack) {
        self.audioPlayer1 = [[AVAudioPlayer alloc] initWithContentsOfURL:[session.firstTrack valueForProperty: MPMediaItemPropertyAssetURL] error:nil];
        self.audioPlayer2 = [[AVAudioPlayer alloc] initWithContentsOfURL:[session.secondTrack valueForProperty: MPMediaItemPropertyAssetURL] error:nil];
        self.audioPlayer1.delegate = self;
        self.audioPlayer2.delegate = self;
        [self startPlayers];
    }
}

- (void)setAudioPlayer:(AudioPlayers)player media:(MPMediaItem *)media {
    switch (player) {
        case PlayerOne:
            self.audioPlayer1 = [[AVAudioPlayer alloc] initWithContentsOfURL:[media valueForProperty: MPMediaItemPropertyAssetURL] error:nil];
            self.audioPlayer1.delegate = self;
            break;
        case PlayerTwo:
            self.audioPlayer2 = [[AVAudioPlayer alloc] initWithContentsOfURL:[media valueForProperty: MPMediaItemPropertyAssetURL] error:nil];
            self.audioPlayer2.delegate = self;
            break;
    }
}

#pragma mark AVAudioPlayer Delegates

- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag {
    if ([player isEqual:self.audioPlayer1]) {
        [self.delegate playerDidFinishPlaying:[UIAlertController alertWithTitle:@"Song Finished" message:[NSString stringWithFormat:@"%@ has finished playing", self.session.firstTrack.title] actionHandler:nil]];
    } else {
        [self.delegate playerDidFinishPlaying:[UIAlertController alertWithTitle:@"Song Finished" message:[NSString stringWithFormat:@"%@ has finished playing", self.session.secondTrack.title] actionHandler:nil]];
    }
    if (!self.audioPlayer1.isPlaying && !self.audioPlayer2.isPlaying) {
        [self.delegate playersDidFinishPlaying];
    }
}

@end

//
//  PlayerView.h
//  Daudio
//
//  Created by Claudius Mbemba on 12/24/16.
//  Copyright © 2016 Claudius Mbemba. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Session, AVAudioPlayer, MPMediaItem;

@protocol PlayerViewDelegate <NSObject>

- (void)playerDidFinishPlaying:(UIAlertController *)alert;
- (BOOL)playersDidFinishPlaying;

@end

typedef NS_ENUM(NSUInteger, AudioPlayers) {
    PlayerOne, PlayerTwo
};

@interface PlayerViewModel : NSObject

@property (nonatomic, strong) Session *session;
@property (nonatomic, strong) id<PlayerViewDelegate>delegate;
@property (nonatomic, strong, readonly) AVAudioPlayer *audioPlayer1;
@property (nonatomic, strong, readonly) AVAudioPlayer *audioPlayer2;

@property (nonatomic) BOOL isPlaying;

- (instancetype)initWithSession:(Session *)session;
- (void)setAudioPlayer:(AudioPlayers)player media:(MPMediaItem *)media;

- (void)startPlayer:(AudioPlayers)player;
- (void)stopPlayer:(AudioPlayers)player;
- (void)pausePlayer:(AudioPlayers)player;
- (void)resetPlayer:(AudioPlayers)player;
- (void)rewindPlayer:(AudioPlayers)player;
- (void)fastFwdPlayer:(AudioPlayers)player;

- (BOOL)sessionIsNew;

- (void)player1Active;
- (void)player2Active;
- (BOOL)playersAreSet;
- (void)startPlayers;
- (void)stopPlayers;
- (void)clearPlayerSession;

@end

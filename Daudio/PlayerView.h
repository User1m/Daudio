//
//  PlayerView.h
//  Daudio
//
//  Created by Claudius Mbemba on 12/24/16.
//  Copyright © 2016 Claudius Mbemba. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Session, AVAudioPlayer;

@protocol PlayerViewDelegate <NSObject>

- (void)playerDidFinishPlaying:(UIAlertController *)alert;
- (BOOL)playersDidFinishPlaying;

@end

@interface PlayerView : NSObject

@property (nonatomic, strong) Session *session;
@property (nonatomic, strong) id<PlayerViewDelegate>delegate;
@property (nonatomic) BOOL isNewSession;

- (instancetype)initWithSession:(Session *)session;
- (void)setAudioPlayer1:(AVAudioPlayer *)player;
- (void)setAudioPlayer2:(AVAudioPlayer *)player;
- (void)player1Active;
- (void)player2Active;
- (BOOL)playersAreSet;
- (void)startPlayers;
- (void)stopPlayers;
- (void)clearPlayerSession;

@end

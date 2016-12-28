//
//  PlayerView.h
//  Daudio
//
//  Created by Claudius Mbemba on 12/24/16.
//  Copyright © 2016 Claudius Mbemba. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Session.h"

@class AVAudioPlayer, MPMediaItem;

@protocol PlayerViewModelDelegate <NSObject>

- (void)playerDidFinishPlaying:(UIAlertController *)alert;
- (void)collectionViewDidSwitch;

@end

typedef NS_ENUM(NSUInteger, AudioPlayers) {
    PlayerOne, PlayerTwo
};

@interface PlayerViewModel : NSObject <UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic, strong) Session *session;
@property (nonatomic, strong) id<PlayerViewModelDelegate>delegate;
@property (nonatomic, strong, readonly) AVAudioPlayer *audioPlayer1;
@property (nonatomic, strong, readonly) AVAudioPlayer *audioPlayer2;
@property (nonatomic) AudioPlayers currentPlayer;

- (instancetype)initWithSession:(Session *)session;
- (void)setAudioPlayer:(AudioPlayers)player media:(MPMediaItem *)media;
- (NSString *)titleForTrack:(TrackNumber)track;
- (NSString *)artistForTrack:(TrackNumber)track;

- (void)startPlayer:(AudioPlayers)player;
- (void)stopPlayer:(AudioPlayers)player;
- (void)pausePlayer:(AudioPlayers)player;
- (void)resetPlayer:(AudioPlayers)player;
- (void)rewindPlayer:(AudioPlayers)player;
- (void)fastFwdPlayer:(AudioPlayers)player;

- (void)startPlayers:(TrackNumber)track;
- (void)stopPlayers;
- (void)pausePlayers;
- (void)resetPlayers;
- (void)rewindPlayers;
- (void)fastFwdPlayers;

- (void)switchToTrack:(TrackNumber)track;
- (BOOL)sessionIsNew;

- (BOOL)playersAreSet;
//- (void)clearPlayerSession;

@end
